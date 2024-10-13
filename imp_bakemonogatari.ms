clearlistener()

try(imp_bakemonogatari)catch(imp_bakemonogatari)
rollout imp_bakemonogatari "Bakemonogatari Importer" (
	local mscale=3.93700787
	
	struct amg_object (
		offset,
		name,
		buffer
		)
	
	struct buffer_offsets (
		offset
		)
	
	fn paddstring len instring = (
		local str=""
		if instring.count <=len then(
			for i = 1 to (len-instring.count) do (str+="0")
			str = (str+instring)
			)
		else (
			for i = 1 to len do (str+="0";str[i]=instring[i])
			)
		str
		)
	
	fn uppercase instring = (
		local upper, lower, outstring
		-- upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		-- lower="abcdefghijklmnopqrstuvwxyz"
		upper="ABCDEF"
		lower="abcdef"
		outstring=copy instring
		for i=1 to outstring.count do (
			j=findString lower outstring[i]
			if (j != undefined) do (
				outstring[i]=upper[j]
				)
			)
		outstring
		)
	
	fn ReadFixedString bstream fixedLen = (
		local str = ""
		for i = 1 to fixedLen do (
			str += bit.intAsChar (ReadByte bstream #unsigned)
			)
		str
		)
	
	fn read fsource = (
		if (fsource!=undefined) AND ((doesFileExist fsource)==true) then(
			delete objects
			
			fpath=getFilenamePath fsource
			fname=getFilenameFile fsource
			fsize=getFileSize fsource
			f = fopen fsource "rb"
			
			buffArray = (buffer_offsets offset:#())
			amgArray = (amg_object offset:#() name:#() buffer:#())

			fileID = readlong f #unsigned
			case fileID of (
				0x4F4D4123: ( -- AMO
					ukn001 = readlong f #unsigned -- offset to another offset table
					ukn002 = readlong f #unsigned -- padding?
					ukn003 = readlong f #unsigned -- padding?
					ukn004 = readlong f #unsigned -- count
					ukn005 = readlong f #unsigned -- offset
					ukn006 = readlong f #unsigned -- count
					ukn007 = readlong f #unsigned -- count, same as ukn001
					ukn008 = readlong f #unsigned -- count?

					if ukn007!=0 do (
						amgArray.offset[ukn007]=0
						amgArray.name[ukn007]=#()
						fseek f ukn007 #seek_set
						for i = 1 to ukn006 do (amgArray.offset[i]=readlong f #unsigned) -- log AMG sections
						for i = 1 to ukn006 do (
							amgOffset = amgArray.offset[i]
							fseek f amgOffset #seek_set
							magic = readlong f #unsigned
							case magic of (
								0x474D4123: (
									amg01 = readlong f #unsigned -- always 0x20, offset?
									amg02 = readlong f #unsigned -- always 0x01, version?
									amg03 = readlong f #unsigned -- always 0x00, padding?
									amg04 = readlong f #unsigned -- count, relates to repeating matrix, bones?
									amg05 = (readlong f #unsigned + amgOffset) -- always 0x20 repeated, offset?
									amg06 = readlong f #unsigned -- count ??
									amg07 = (readlong f #unsigned + amgOffset) -- offset to name table
									if amg05!=0 do ( -- matrix
										fseek f amg05 #seek_set
										amgArray.buffer[amg04]=0
										for x = 1 to amg04 do ( -- loop object table
											m11 = (readfloat f)
											m12 = (readfloat f)
											m13 = (readfloat f)
											m14 = (readfloat f)
											m21 = (readfloat f)
											m22 = (readfloat f)
											m23 = (readfloat f)
											m24 = (readfloat f)
											m31 = (readfloat f)
											m32 = (readfloat f)
											m33 = (readfloat f)
											m34 = (readfloat f)
											amg05_01 = readlong f #unsigned -- ?? flags, 2 shorts?
											amg05_02 = (readlong f #unsigned + amgOffset) -- buffer offset
											amg05_03 = readlong f #unsigned -- offsets to the next entry?
											amg05_04 = readlong f #unsigned -- offsets to some random entry? maybe for child info?
											amg05_05 = readlong f #unsigned -- offsets to some random entry? maybe for parenting info?
											amg05_06 = readlong f #unsigned -- always 0x00, padding
											amg05_07 = readlong f #unsigned -- always 0x00, padding
											amg05_08 = readlong f #unsigned -- always 0x00, padding
											amgArray.buffer[x]=amg05_02
											)
										for x = 1 to amg04 do ( -- loop through object sections
											fseek f amgArray.buffer[x] #seek_set
											Print ("Object @ 0x"+((bit.intAsHex(amgArray.buffer[x]))as string))
											amg05_10 = readlong f #unsigned + 1 -- object index
											
											case amg05_10 of ( -- object case
												1: ( -- vertex stuff??
													amg05_11 = (readlong f #unsigned + amgOffset) -- offset to subheader
													
													fseek f 0x88 #seek_cur
													
													vertArray=#()
													uvwArray=#()
													normArray=#()
													faceArray = #()
													
													-- 4035
													for x = 1 to 100 do (
														vx = readfloat f
														vy = readfloat f
														vz = readfloat f
														nx = readfloat f
														ny = readfloat f
														nz = readfloat f
														tu = readfloat f
														tv = readfloat f
														append vertArray [vx,vy,vz]
														append uvwArray [0,0,0]
														)
													idx=0
													for x = 1 to (vertArray.count/3) do (
														fa = 1 + idx
														fb = 2 + idx
														fc = 3 + idx
														idx+=1
														if (mod x 2)==0 then(
															append faceArray [fa,fc,fb]
															)
														else(
															append faceArray [fa,fb,fc]
															)
														)
													-- print faceArray
													-- fseek f meshArray.face_offset[m] #seek_set
													-- for x = 1 to meshArray.numobj[m] do (
													-- face_count = readshort f #unsigned
													-- matID = readshort f #unsigned
													-- fa = readshort f #unsigned + 1
													-- fb = readshort f #unsigned + 1
													-- fc = readshort f #unsigned + 1
													-- append faceArray [fa,fb,fc]
													-- for i = 1 to (face_count-3) do (
													-- fa = fb
													-- fb = fc
													-- fc = readshort f #unsigned + 1
													-- if (mod i 2)==1 then(append faceArray [fa,fc,fb])
													-- else(append faceArray [fa,fb,fc]))
													msh = mesh vertices:vertArray faces:faceArray
													msh.numTVerts = uvwArray.count
													buildTVFaces msh
													msh.displayByLayer = false
													msh.backfacecull = on
													msh.wirecolor = random (color 0 0 0) (color 255 255 255)
													-- msh.material = mat
													-- for j = 1 to uvwArray.count do setTVert msh j uvwArray[j]
													-- for j = 1 to faceArray.count do setTVFace msh j faceArray[j]
													-- for j = 1 to matArray.count do setFaceMatID msh j matArray[j]
													-- for j = 1 to normArray.count do setNormal msh j normArray[j]
													-- max tool zoomextents
													convertTo msh PolyMeshObject
													select msh
													-- modPanel.setCurrentObject msh
													-- subobjectLevel = 1
													)
												-- default:(format "Unrecognized Type: %" objType)
												) -- end object case
											)
										) -- emd matrix check
									if amg07!=0 do ( -- name table
										fseek f amg07 #seek_set
										nameArray=#();nameArray[amg04]=""
										for x = 1 to amg04 do (
											nameArray[x]=ReadFixedString f 32
											)
										amgArray.name[i]=nameArray
										) -- end check for name table
									)
								default:(Print "not a AMG magic")
								) -- end case of
							) -- end AMG Loop
						) -- end AMG check
					if ukn005!=0 do (
						fseek f ukn001 #seek_set
						buffArray.offset[ukn004]=0
						for i = 1 to ukn004 do (
							ukn005_01 = readlong f #unsigned + 1 -- index
							ukn005_02 = readlong f #unsigned -- offset
							ukn005_03 = readlong f #unsigned -- offset of entry end? if zero end of table
							ukn005_04 = readlong f #unsigned -- padding?
							ukn005_05 = readlong f #unsigned -- offset of the last entry? if zero start of table
							ukn005_06 = readlong f #unsigned -- padding?
							ukn005_07 = readlong f #unsigned -- padding?
							ukn005_08 = readlong f #unsigned -- padding?
							buffArray.offset[i]=ukn005_02
							)
						for i = 1 to ukn004 do (
							fseek f buffArray.offset[i] #seek_set
							for x = 1 to 16 do (
								ukn005_02_01 = readlong f #unsigned -- ??
								ukn005_02_02 = readlong f #unsigned + 1 --  index
								ukn005_02_03 = readlong f #unsigned -- offsets to sections in various AMG chunks
								ukn005_02_04 = readlong f #unsigned -- ??
								)
							)
						)
					) -- end AMO case
				0x4D4D4123: ( -- AMM
					)
				0x4B534223: ( -- BSK
					)
				0x434D4123: ( -- AMC
					)
				0x544D4123: ( -- AMC
					)
				default:(Print "No Action, New Type?")
				) -- end fileID case
			Print ("Last Read @ 0x"+((bit.intAsHex(ftell f))as string))
			fclose f
			)
		else(
			Print "Aborted."
			)
		)
	)


imp_bakemonogatari.read(
	"D:\\_3DMODELS\\Ripped\\Bakemonogatari\\PSP_GAME\\USRDIR\\rom\\rom\\_NULL_\\_NULL__00000b0a"
	GetOpenFileName caption:"Select Bakemonogatari Model" types: "model (*.amo)|*.amo|All files (*.*)|*.*|"
	)