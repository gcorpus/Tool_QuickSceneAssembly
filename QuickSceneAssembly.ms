try(closeRolloutFloater RolloutFloaterTemplate) catch()

--Declare global variables for our functions.
global num_prim =1
global start_ = 0
global final_ = 100


--Rollout 1: Create geoemtry, random position,rotation and scale,  and add modifiers.
rollout AddGeometryTemplate "Geometry"
(
	--Create the buttons, spinners, dropdownlist and groupbox.
	--Create primitives.
	dropdownlist GeoList " Add Primitives: " items:#("Box","Sphere","Cylinder","Torus","Teapot","Cone","GeoSphere","Tube","Pyramid","Plane")  width: 90
	--Specify number of objects to create.
	spinner NumGeo "N° of Primitives: "  type:#integer  range: [1,1000,1] width: 165 offset:[0,5]
	--Create a dummy , transformation 0,0,0.
	button NewDummy "Create Dummy" pos:[50,80]
	--Assign random position to selected objects.
	button PosObj "Position" align:#left across:3 pos:[9, 127]
	--Assign random rotation to selected objects.
	button RotObj "Rotation" align:#left pos:[70, 127]
	--Assign random scale to selected objects.
	button SclObj "Scale" align: #left pos:[133, 127]
	--Group buttons.
	groupBox group1 "Random Transformations" pos:[2,107] width:180 height:50
	--Add modifiers to selected objects.
	dropdownlist ModObj " Add Modifiers: " items:#("Bend","Edit Poly","Mirror","ProOptimizer","Symmetry","TurboSmooth","Twist","Unwrap UVW") width: 100
	
	--Function of GEOLIST: This function recognize the geometry that must be created, and calculate the position.
	function geo id num_prim =
	(
		clearSelection()
		n = 0
		x = 0
		y = 0
		z = 0
		
		for i  in 1 to (num_prim) do
		(
			
			case id of  --Calculate the position of the next geometry.
			(
				4: x = n * 90
				5: x = n * 90
				default: x = n * 60
			)
			
			case id of   --Create the geometry according with an array given.
			(
				1: selectmore (box pos:[x,y,z]) --items [1] box
				2: selectmore (sphere pos:[x,y,z]) --items [2] sphere
				3: selectmore (cylinder pos:[x,y,z]) --items [3] cylinder
				4: selectmore (torus pos:[x,y,z]) --items [4] torus
				5: selectmore (teapot pos:[x,y,z]) --items [5] teapot
				6: selectmore (cone pos:[x,y,z]) --item[6] cone
				7: selectmore (geosphere pos:[x,y,z]) --item[7] geosphere
				8: selectmore (tube pos:[x,y,z]) --item[8] tube
				9: selectmore (pyramid pos:[x,y,z]) --item[9] pyramid
				10: selectmore (plane pos:[x,y,z]) --item[10] plane
			)
			n = n + 1
			
		)
		
	) 
	
	on GeoList selected id do --Call the previous function GEO and give the parameters.
	(
		geo id num_prim
	)	
	
	on NumGeo changed val do --Reasign value to an variable.
	(
		num_prim = val
	)
	
	on NewDummy pressed do --Create a new dummy in position 0,0,0
	(
		Dummy pos:[0,0,0] isSelected:on
	)
	
	on PosObj pressed do --Calculate the random position of selected objects.
	(
		array_obj = (for s in $selection collect s) --Get nodes into an array
		
		for s in 1 to array_obj.count do  --Calculate the random values for x,y,z and give a flag for the sign (+,-).
		(
			posx = random 1 30 --position x between 1 and 30.
			posy = random 1 30 --position y between 1 and 30.
			posz = random 1 30 --position z between 1 and 30.
			sign = random 1 2 --Flag for sign +,-
			 
			if sign == 1 then  --If sign is + the calculated value is added in their 3 coordenates.
			(
				x = array_obj[s].pos.x + posx --new value x
				y = array_obj[s].pos.y + posy --new value y
				z = array_obj[s].pos.z + posz --new value z
			)
			else  --If not, (the sign is -), the calculated value is rested in their 3 coordenates.
			(
				x = array_obj[s].pos.x - posx  --new value x
				y = array_obj[s].pos.y - posy ---new value y
				z = array_obj[s].pos.z - posz --new value z
			)
			
			--To the object in turn assign their new values of x,y and z.
			array_obj[s].pos.x = x			
			array_obj[s].pos.y = y	
			array_obj[s].pos.z = z	
			
		)
	)
	
	on RotObj pressed do --Calculate the random rotation of selected objects.
	(
		array_obj = (for s in $selection collect s) --Get the nodes into an array.
		
		for s in 1 to array_obj.count do   --Calculate the random values for x,y,z and give a flag for the sign (+,-).
		(
			posx = random 0 1 --rotation x between 0 and 1
			posy = random 0 1 --rotation y between 0 and 1
			posz = random 0 1 --rotation z between 0 and 1
			sign = random 1 2 --flag for sign +,-
			 
			if sign == 1 then  --If sign is + the calculated value is added in their 3 coordenates.
			(
				x = array_obj[s].rotation.x + posx  --new value x
				y = array_obj[s].rotation.y + posy --new value y
				z = array_obj[s].rotation.z + posz --new value z
			)
			else  --If not, (the sign is -), the calculated value is rested in their 3 coordenates.
			(
				x = array_obj[s].rotation.x - posx  --new value x
				y = array_obj[s].rotation.y - posy  --new value y
				z = array_obj[s].rotation.z - posz --new value z
			)
			
			--To the object in turn assign their new values of x,y and z.
			array_obj[s].rotation.x = x			
			array_obj[s].rotation.y = y	
			array_obj[s].rotation.z = z	
			
		)				
	
	)	
	
	on SclObj pressed do --Calculate the random scale of selected objects.
	(
		array_obj = (for s in $selection collect s)  --Get the nodes into an array.
		
		for s in 1 to array_obj.count do   --Calculate the random values for x, y and z, where the three coordenates will have the same value, and give a flag for the sign (+,-).
		(
			scale_x = random 0.1 0.99 --Scale x,y and z between 0.1 and 0.99
			
			sign = random 1 2  --flag for sign +,-
			 
			if sign == 1 do --If sign is + the calculated value is added in their 3 coordenates.
			(
				x = array_obj[s].scale.x + scale_x --new value x
				y = array_obj[s].scale.y + scale_x --new value y
				z = array_obj[s].scale.z + scale_x --new value z
			)
			if sign == 2 do  --If not, (the sign is -), the calculated value is rested in their 3 coordenates.
			(
				x = array_obj[s].scale.x - scale_x  --new value x
				y = array_obj[s].scale.y - scale_x --new value y
				z = array_obj[s].scale.z - scale_x --new value z
			)
			
			--To the object in turn assign their new values of x,y and z.
			array_obj[s].scale.x = x			
			array_obj[s].scale.y = y	
			array_obj[s].scale.z = z	
			
		)
	)
	
	on ModObj selected id do  --Assign a modifier by object selected.
	(
		m_obj = getCurrentSelection() --Get in an array the selected objects.
		mod_obj = (for i in $selection collect i) --Get other array with the same objects.
		
		for i in 1 to mod_obj.count do --A loop execute the same number of times as number of selected objects.
		(
			clearSelection() --Deselect all objects in the scene.
			select mod_obj[i] --Select only the object in turn according to the  array.
			
			case id of --Evaluate id of the chosen modifier and assign to the object.
			(
				1: mod_obj[i] = modPanel.addModToSelection (Bend ()) ui:on --Bend modifier
				2: mod_obj[i] = modPanel.addModToSelection (Edit_Poly ()) ui:on --EditPoly modifier
				3: mod_obj[i] = modPanel.addModToSelection (mirror ()) ui:on --mirror modifier
				4: mod_obj[i] = modPanel.addModToSelection (ProOptimizer ()) ui:on --prooptimizer modifier
				5: mod_obj[i] = modPanel.addModToSelection (symmetry ()) ui:on --symmetry modifier
				6: mod_obj[i] = modPanel.addModToSelection (TurboSmooth ()) ui:on --turbosmooth modifier
				7: mod_obj[i] = modPanel.addModToSelection (Twist ()) ui:on  --twist modifier
				8: mod_obj[i] = modPanel.addModToSelection (Unwrap_UVW ()) ui:on --Unwrap_uvw modifier
			)
	
		)
		--Then the for loop is ended, select again all the object processed.
		select m_obj 
	)
	
)

rollout SelectObjectsTemplate "Select / Delete Objects" 
(
	--Create the dropdownlist, and button of this rollout.
	--Select objects by class.
	dropdownlist SelectObjects "Select objects: " items:#("all objects","geometry","helpers","lights","cameras") width: 85 align:#center
	--Reset tranformation original of selected objects ( position, rotation, scale).
	button ResetObjects "Reset Object Transformation"
	--Delete selected objects.
	button DObjects "Delete selected objects"

	
	on SelectObjects selected val do --Action of selected all objects by class into the scene.
	(
		clearSelection() --Deselect all object of the scene.
		
		--According to class, all objects of that class wil be selected.
		case val of
			(
				1: for i in objects do selectmore i  --All objects in scene 
				2: for i in geometry do selectmore i --All geometry in scene
				3: for i in helpers do selectmore i  --All helpers in scene
				4: for i in lights do selectmore i --All lights in scene
				5: for i in cameras do selectmore i --All cameras in scene
		
			)
	)
	
	on ResetObjects pressed do --According to the selected objects, these will be reset in your 3 transformations (position, rotation,scale).
	(
		for i in $selection  do --In all selected objects in scene.
			(
				--Position (0,0,0)
				$selection.pos.x = 0 
				$selection.pos.y = 0 
				$selection.pos.z = 0
				--Rotatio (0,0,0)
				$selection.rotation.x = 0
				$selection.rotation.y = 0
				$selection.rotation.z = 0
				--Scale (1,1,1)
				$selection.scale.x = 1
				$selection.scale.y = 1
				$selection.scale.z = 1
					
			)
	)
	
	on DObjects pressed do --In all selected objects in scene.
	(
		delete $ --Delete selected objects.
	)

)

rollout MaterialsObjectsTemplate "Color /  Textures & Materials"
(
	--Create dropdown and labels of this rollout.
	--Color list for the meshes.
	dropdownlist ColorObj " Colors:" items:#("red","blue","yellow","green","orange","brown","gray","black") width: 70 align:#left across:2
	--Materials list for the meshes.
	dropdownlist MaterialObj  " Materials: " items: #("ornament", "wood","grass", "gold","stone") width: 75 align:#right
	--Message of warning, In materials is necessary cover a requirement.
	label MaterialMessage " Attention: In menu Materials, "
	label MaterialMessage2 "you have to charge a Vray"
	label MaterialMessage3 " material library before to use it."
	
	--Assign color to selected geometry or objects, according to the list.
	on ColorObj selected val do
	(
		$.material = undefined --Clean the object of any other material.
		case val of
			(
				1: for i in $selection do $.wirecolor =red   --Assign color red to mesh
				2: for i in $selection do $.wirecolor =blue   --Assign color blue to mesh
				3: for i in $selection do $.wirecolor =yellow  --Assign color yellow to mesh
				4: for i in $selection do $.wirecolor =green  --Assign color green to mesh
				5: for i in $selection do $.wirecolor =orange  --Assign color orange to mesh
				6: for i in $selection do $.wirecolor =brown  --Assign color brown to mesh
				7: for i in $selection do $.wirecolor =gray  --Assign color gray to mesh
				8: for i in $selection do $.wirecolor =black  --Assign color black to mesh

			)
	)	
	
	on MaterialObj selected val do  --Assign material to selected meshes.
	(
		$.material = undefined --Clean the object of any other material.
		case val of 
		(
			--According to the Material Editor
			1: for i in $selection do $.material = meditMaterials[1] --Assign material 1
			2: for i in $selection do $.material = meditMaterials[2] --Assign material 2
			3: for i in $selection do $.material = meditMaterials[3] --Assign material 3
			4: for i in $selection do $.material = meditMaterials[4] --Assign material 4
			5: for i in $selection do $.material = meditMaterials[5] --Assign material 5
		)
		
		--Get the collection of selected objects as backup in two arrays.
		obj = getCurrentSelection()
		obj_mod = (for i in $selection collect i)
		
		--Process each element in array for assign a modifier that will help to the Vray material.
		for i in 1 to obj_mod.count do
		(
			clearSelection() --Deselect all object in scene.
			select obj_mod[i] --Select only one object
			obj_mod[i] = modPanel.addModToSelection (UVWMap ()) ui:on --And assign to this the UVWMap modifier.
		)
		
		--When the for loop ends, all the processed objects are selected again.
		select obj 
	)
	
	
)

rollout AnimationObjectsTemplate "Animation"
(
	--Create spinners, dropdown, button and groups.
	--Get the start of animation in frames.
	spinner TStart "Start: " type:#integer range:[0,1000,0] align:#left across:2 pos:[12, 30]
	--Get the final of animation in frames.
	spinner TFinal "End: " type:#integer range:[1,1000,100] align:#right pos:[105, 30]
	--Create a group of frames ranges.
	groupBox group1 "Frames Range " pos:[4,5] width:178  height:50
	--Get what type of tranformation animation will be.
	dropdownlist TransAnim " Transformations: " items:#("None","Rotation","Scale")  width:90
	--Get what rute of animation will be.
	dropdownlist RutesAnim  " Rutes: " items:#("None","Circular","Elipse","Star","Twister","Abstract 'G'","Abstract '6'") width: 90
	--Execute the animation
	button BAnim "Animate" pos:[112,80] width:68 height:60
	--Delete all key frames of selected objejcts.
	button NonAnim "Remove Rotation&Scale" --pos:[45, 155]
	
	
	--Declare and assign values to glabal variables.
	global trans_anim_ = 1
	global rute_anim_ = 1
	
	--Function of built the animation with the information given by the user.
	function AssemblyAnimation start final trans_anim rute_anim =
	(
		--Obtain nodes of selected objects	
		obj_anim =(for i in $selection collect i)
		
		
		--Start the animation action
		animate on 
		(
		
			--Get the start an final values of our animation
			for t in start to final by 5 do
			(
				
				--Create Random Animation of Rotation of selected objects	
				if trans_anim == 2 do
				(
					for s in 1 to obj_anim.count do 
					(
						at time t
						(
							--Calculate random position values and a flag of sign +,-
							posx = random 0 1
							posy = random 0 1
							posz = random 0 1
							sign = random 1 2
							 
							--Process the values and calculate the x,y and z coordenates.
							if sign == 1 then
							(
								x = obj_anim[s].rotation.x + posx
								y = obj_anim[s].rotation.y + posy
								z = obj_anim[s].rotation.z + posz
							)
							else
							(
								x = obj_anim[s].rotation.x - posx
								y = obj_anim[s].rotation.y - posy
								z = obj_anim[s].rotation.z - posz
							)
							
							obj_anim[s].rotation.x = x			
							obj_anim[s].rotation.y = y	
							obj_anim[s].rotation.z = z	
						)
						
					)				
					
					
				)
				
				--Create Random Animation of Scale of selected objects	
				if trans_anim == 3 do
				(
					for s in 1 to obj_anim.count do 
					(
						at time t
						(
							--Calculate random value for scale of objects and a flag of sign +,-
							posx = random 0 1
							sign = random 1 2
							 
							--Process the values and calculate the x,y and z coordenates.
							if sign == 1 then
							(
								x = obj_anim[s].scale.x + posx
								y = obj_anim[s].scale.y + posx
								z = obj_anim[s].scale.z + posx
							)
							else
							(
								x = obj_anim[s].scale.x - posx
								y = obj_anim[s].scale.y - posx
								z = obj_anim[s].scale.z - posx
							)
							
							obj_anim[s].scale.x = x			
							obj_anim[s].scale.y = y	
							obj_anim[s].scale.z = z	
						)
						
					)				
					
				)
				
			)
		)
	
		--Process of chosen rute
		--If the option isn´t None in the menu do:
		if rute_anim != 1 do
		(
			--Get selected objejcts into an array.
			rute_obj = (for i in $selection collect i)

			--Process the information for get what rute will be assign.
			for n in 1 to rute_obj.count do
			(	
			
				--Create a path constraint
				pathconstraint = path_constraint() 
				
				--Built the rute according to the order.
				if rute_anim == 2 do (rute_path = circle()   rute_path.radius = 300)   --Circle rute
				if rute_anim == 3 do (rute_path = Ellipse pos:[0,0,10] length:250 width:500 ) --Ellipse rute
				if rute_anim == 4 do (rute_path = Star radius1:300 radius2:100 numPoints:8 ) --Start rute
				if rute_anim == 5 do (rute_path = Helix radius1:150 radius2:0 height:250 turns:5 ) --Helix rute
				if rute_anim == 6 do 
				(
					rute_path = text size:400  
					rute_path.text = "G"  
					rute_path.font = "GiddyupStd"  --"G" shape rute
				)
				
				if rute_anim == 7 do 
				(
					rute_path = text size:400  
					rute_path.text = "6"  
					rute_path.font = "GiddyupStd" --"6" shape rute
				)
				
				--Equal the pos of paths to the pos of the objects that will be animate.
				rute_path.pos = rute_obj[n].pos
				--Assign a controller to our object.
				rute_obj[n].position.controller = pathconstraint
				--Append the rute to the constraint.
				pathconstraint.appendTarget rute_path 50
				--Assign rute to the constraint.
				pathconstraint.path = rute_path
				--Execute the cosntraint with the rute chosen.
				pathconstraint.setWeight 1 100
	
			)	

		)
		
	)
			

	
	on TStart changed val do --Assign new value to variable start_
	(
		start_ = val
	)
	
	on TFinal changed val do --Assign new value to variable final_
	(
		final_ = val
		if final_ <=start_ do
		(
			final_ = final_ +1
			val = final_
		)			
	)
	
	on TransAnim selected id do --Assign new value to variable trans_anim_
	(
		trans_anim_ = id
	)
	
	on RutesAnim selected id do --Assign new value to variable rute_anim_ 
	(
		rute_anim_ = id
	)
	
	on BAnim pressed do --Execute the function AssemblyAnimation and sent the variables needed.
	(
		AssemblyAnimation start_ final_ trans_anim_ rute_anim_
	)
	
	on NonAnim pressed do --Delete  key frames of rotation and scale of selected objects.
	(
		deletekeys $.rotation.controller
		deletekeys $.scale.controller
	)
	
)

rollout LightsObjectsTemplate "Illumination"
(
	--Create button, grupobox, dropdownlist.
	--Create set of Vray lights around of the selected objects.
	button SetLights "Lights Around" align:#center pos:[35,25] width:120
	--Create a top Vray light above the selected object.
	button TopLight "Top Light" align:#left across:2 pos:[18,53]
	--Create a down Vray light to the selected object.
	button BottomLight "Bottom Light" pos:[90,53]
	--Group of Vray lights
	groupBox group1 "VRay Lights" pos:[3,5] width:180 height:80
	--Assign a color to the render environment
	dropdownlist EnvLight "Color Environment: " items:#("Black", "Dark Gray", "Light Gray","White") width: 100 align:#center
	
	
	--Create a set of 4 light , left, right, front, back, calculate the average of position of the selected objects for create the lights.
	on SetLights pressed do 
	(
		--Inicialize variables
		x = 0
		y = 0
		z = 0
		--Get collection og position values of selected objects.
		top_pox = (for i in $selection collect i.pos.x)
		top_poy = (for i in $selection collect i.pos.y)
		top_poz = (for i in $selection collect i.pos.z)

		for i in 1 to top_poz.count do --Calcutae new values
		(
			x = x + top_pox[i]
			y = y + top_poy[i]
			z = z + top_poz[i]
		)

		x = x / top_poz.count
		y = y / top_poz.count
		z = z / top_poz.count
		
		--According to the result the lights are created.
		front =  VrayLight intensityAt:100 light_length:100 light_width:100 pos:[x + 150 , y , z ] invisible: on --front
		rotate front (angleaxis 90 [0,1,0])
		back = VrayLight intensityAt:100 light_length:100 light_width:100 pos:[x - 150 , y , z ]  invisible: on --back
		rotate back  (angleaxis -90 [0,1,0])
		left = VrayLight intensityAt:100 light_length:100 light_width:100 pos:[x  , y + 150, z ]  invisible: on --left
		rotate left  (angleaxis -90 [1,0,0])
		right = VrayLight intensityAt:100 light_length:100 light_width:100 pos:[x , y - 150, z ]  invisible: on --right
		rotate right  (angleaxis 90 [1,0,0])
		
		--Scale 3x the lights
		scale front [3,3,3]
		scale back [3,3,3]
		scale left [3,3,3]
		scale right [3,3,3]
		
		
	)
	
	on TopLight pressed do --Create the top lights
	(
		--Inicialize variables
		x = 0
		y = 0
		z = 0
		--Get collection og position values of selected objects.
		top_pox = (for i in $selection collect i.pos.x)
		top_poy = (for i in $selection collect i.pos.y)
		top_poz = (for i in $selection collect i.pos.z)

		for i in 1 to top_poz.count do  --Calcutae new values
		(
			x = x + top_pox[i]
			y = y + top_poy[i]
			z = z + top_poz[i]
		)

		x = x / top_poz.count
		y = y / top_poz.count
		z = z / top_poz.count

		--According to the result the light is created.
		vr_light = VrayLight intensityAt:100 light_length:100 light_width:100 pos:[x,y, z + 150]  invisible: on
		--Scale 3x the light
		scale vr_light  [3,3,3]
		--Select the light
		select vr_light
	)
	
	on BottomLight pressed do --Create the bottom light
	(
		--Inicialize variables
		x = 0
		y = 0
		z = 0
		--Get collection og position values of selected objects.
		top_pox = (for i in $selection collect i.pos.x)
		top_poy = (for i in $selection collect i.pos.y)
		top_poz = (for i in $selection collect i.pos.z)

		for i in 1 to top_poz.count do --Calcutae new values
		( 
			x = x + top_pox[i]
			y = y + top_poy[i]
			z = z + top_poz[i]
		)

		x = x / top_poz.count
		y = y / top_poz.count
		z = z / top_poz.count

		--According to the result the light is created.
		vr_light = VrayLight intensityAt:100 light_length:100 light_width:100 pos:[x,y, z - 150]  invisible: on
		--Scale 3x the light
		scale vr_light  [3,3,3]
		--Rotate 180° the light
		rotate vr_light (angleaxis 180 [0,1,0])
		--Select the light
		select vr_light
	)
	
	on EnvLight selected id do --Give color to the render environment
	(
		case id of 
		(
			1: backgroundColor = color 0 0 0 --black
			2: backgroundColor = color 25 25 25 --dark gray
			3: backgroundColor = color 100 100 100 --light gray
			4: backgroundColor = color 230 230 230  --white
		)
		
	)
)

rollout CameraObjectsTemplate "Cameras" --Create camera 
(
	button CreateCamera "Create Camera From View " --Create camera from current view
	
		on CreateCamera pressed do
	(
		newcamera = (macros.run "Lights and Cameras" "PhysicalCamera_CreateFromView")
		
	)
)

rollout VRayPropertiesTemplate "VRay Properties"  --VRay Properties
(
	--Select the Image Sampler type of Vray
	dropdownlist ImageSampler " Image Sampler Type: " items:#("Bucket","Progressive")  width:120 --align:#center
	--Global Illumination Active
	checkbox GI "Enable GI" checked:true pos:[220,20]
	--BUCKET and your properties
	spinner BaseSubdivs "Min subdivs: " type:#integer range: [1,1000,1] width:100 pos:[47,70] --Minimun subdivisions
	spinner FineSubdivs "Max subdivs: " type:#integer range:[1,1000,24] width:97 pos:[52,90] --Maximum subdivisions
	spinner NoiseThreshold "Noise threshold: " range:[0.0,100.0,0.01] width:97 pos:[62,110] --Noise in the render
	groupBox Bucket  "Bucket "   align:#left pos:[5,50] width:170 height:100
	
	--PROGRESSIVE and your properties
	spinner MinSamples "Min. subdivs: " type:#integer range:[1,1000,1] width:100 pos:[225,70] --Minimum subdivisions
	spinner MaxSamples "Max. subdivs: " type:#integer range:[1,1000,100]  width:100 pos:[228,90] --Maximum subdivisions
	spinner RenderTime "Render time (min): " range:[0.0,100.0,1.0] width:100  pos:[245,110] --Render time
	spinner NoiseTresh "Noise threshold: " range:[0.0,20.0,0.005] width:100 pos:[236,130] --Noise in the render
	groupBox Progressive  "Progressive "   align:#right  pos:[180,50] width:170 height:100 

	
	on ImageSampler selected id do  --Select the Image Sampler type of Vray
	(
		vr = renderers.current
		case id of
		(
		1: (vr.imageSampler_type = 1) --Bucket
		2: (vr.imageSampler_type = 3 )--Progressive
		)
	)
	
	on GI changed theState do  --Global Illumination
	(
		vr = renderers.current
		
		if GI.state == true do
		(
			vr.gi_on = on  --Active
		)
		
		if GI.state == false do
		(
			vr.gi_on = off --Desactive
		)
		
	)
	
	on  BaseSubdivs changed val do  --Min. subdivs BUCKET
	(
		vr = renderers.current
		vr.twoLevel_baseSubdivs = val  
	)
	
	on  FineSubdivs changed val do  --Max. subdivs BUCKET
	(
		vr = renderers.current
		vr.twoLevel_fineSubdivs = val  
	)
	
	on  NoiseThreshold changed val do  --Noise threshold  BUCKET
	(
		vr = renderers.current
		vr.twoLevel_threshold = val  
	)
	
	on MinSamples changed val do  --Min. subdivs  PROGRESSIVE
	(
		vr = renderers.current
		vr.progressive_minSamples = val
	)
	
	on MaxSamples changed val do --Max. subdivs  PROGRESSIVE
	(
		vr = renderers.current
		vr.progressive_maxSamples = val
	)
	
	on  RenderTime changed val do   --Render time  PROGRESSIVE
	(
		vr = renderers.current
		vr.progressive_max_render_time = val
	)
	
	on NoiseTresh changed val do  --Noise threshold  PROGRESSIVE
	(
		vr = renderers.current
		vr.progressive_noise_threshold = val
	)
	
)

rollout RenderObjectsTemplate "Render"
(
	--Create dropdown, spinners, button, editbox
	--Select renderer
	dropdownlist SelectRender " Select Renderer : " items:# ("V-Ray Adv 3.40", "V-Ray RT 3.40","Mental Ray","Default Scanline")
	--Select output[one frame or multiframes]
	dropdownlist RenderTimeout "Time Output:" items:#("Single frame"," Frame range") width: 120
	--Range of the frames start
	spinner FrameRangeStart " Range: " range:[0,1000,start_] align:#left across: 2 type:#integer
	--Range of the frames final
	spinner FrameRangeFinal "to  " range:[0,1000,final_] type:#integer
	--Resolution: width
	spinner RWidth "Width:  " type:#integer range:[1,2000,640] width:80 align:#left
	--Resolution: height
	spinner RHeight "Height: " type:#integer range:[1,2000,480] width:80 align:#left
	--Name of the output file
	edittext NameOutput "File name: "
	--Type of file [jpeg, png, mov, exr. tif]
	dropdownlist TypeOutput "Save as type : " items:# ("JPEG File", "MOV Quick Time File", "OpenEXR Image File", "PNG Image File", "TIF Image File")
	--Execute render
	button DoRender "Render" width: 70 height:30
	
	
	global R_timeout = 1  --Render_Timeout : sigle or interval
	global R_ranges = 0 --Range start interval: default 0
	global R_rangef = 100 --Range final interval : default 100
	global R_width = 640 --Resolution width; 640
	global R_height = 480 --Resolution height: 480
	global R_filename = "untitle" --Name of our output file render
	global R_filetype = ".jpeg" --File type : jpeg, png, mov, exr
	global r = renderers.current = V_Ray_Adv_3_40_01 ()  --Execute the function and assign our default renderer [VRay]


    --Function that process the render with its variables
	function CreateRender R_timeout R_ranges R_rangef R_width R_height R_filename R_filetype =
	(
		
		--ensure the  existence of render folder, if this not exist it will be create
		R_pathfile= maxFilePath  
		R_dir = R_pathfile + "renders\\" 
		makeDir R_dir all:false
		
		--Identify if is a single frame
		if R_timeout == 1 do
		(
			--Render process
			R_output = R_dir + R_filename + R_filetype --directory of render output files	
			undisplay (render  outputwidth:R_width outputheight:R_height  outputfile:R_output) --Excecute the render process and save the result
		)
		--Identify if is a sequence of frames
		if R_timeout == 2 do
		(
			--Get number of frames
			range = (R_rangef - R_ranges) + 1
			count = 0
			
			--Loop of render process
			for i in 1 to range do
			(
				R_num = R_ranges + count
				R_output = R_dir + R_filename +"_"+(R_num as string) + R_filetype --directory of render output files	
				--R_output = R_dir + R_filename + R_filetype --directory of render output files	
				undisplay (render  outputwidth:R_width outputheight:R_height  frame:R_num outputfile:R_output) --Excecute the render process and save the result
				count = count + 1
			)
			
		)
		
		
		
	)
		
	--Select  and assign the renderer [4 options]
	on SelectRender selected id do
	(
		case id of
		(
			1: renderers.current = V_Ray_Adv_3_40_01()
			2: renderers.current = V_Ray_RT_3_40_01()
			3: renderers.current = mental_ray_renderer()
			4: renderers.current = Default_Scanline_Renderer()
			
		)
		
		--If the renderer is  V_Ray_Adv_3_40_01(), the process execute a extra window with VRay properties
		if id == 1 do
		(
			--This window contain basic properties of render: min/max subdivisions, render time, noise.
			createDialog VRayPropertiesTemplate width: 355  height: 155
		)
		
	)
	
	on RenderTimeout selected id do  --Get the value if is a sigle frame or a sequence frames.
	(
		case id of
		(
			1: R_timeout = 1 --single frame
			2: R_timeout = 2 --sequence frames
		)
	)
	
	on FrameRangeStart changed val do --Get the value of frame range : start
	(
		R_ranges = val
	)
	
	on FrameRangeFinal changed val do --Get the value of frame range : final
	(
		R_rangef = val
	)
	
	
	on RWidth changed  val do --Get the value of resolution: width
	(
		R_width = val
	)
	
	on RHeight changed val do --Get the value of resolution: height
	(
		R_height = val
	)
	
	on NameOutput entered txt do --Get string of filename given by user
	(
		if txt != "" do
		(
			R_filename = txt
		)
	)
	
	on TypeOutput selected id do  --Get the type file according with id of menu.
	(
		case id of
		(
			1: R_filetype = ".jpeg"
			2: R_filetype = ".mov"
			3: R_filetype = ".exr"
			4: R_filetype = ".png"
			5: R_filetype = ".tif"
		)
	)
	
	on DoRender pressed do --Execute the final render with the previous variables
	(		
		--Call the finction CreateRender and sent the variables.
		CreateRender R_timeout R_ranges R_rangef R_width R_height R_filename R_filetype
	)
	
)

--Declare and assign value as a new rollout floater
RolloutFloaterTemplate = newrolloutfloater "Quick Scene Assembly" 200 400
--Show Rollout of all section of the script
addrollout AddGeometryTemplate RolloutFloaterTemplate
addrollout SelectObjectsTemplate RolloutFloaterTemplate
addrollout MaterialsObjectsTemplate RolloutFloaterTemplate
addrollout AnimationObjectsTemplate RolloutFloaterTemplate
addrollout LightsObjectsTemplate RolloutFloaterTemplate
addrollout CameraObjectsTemplate RolloutFloaterTemplate
addrollout RenderObjectsTemplate RolloutFloaterTemplate









