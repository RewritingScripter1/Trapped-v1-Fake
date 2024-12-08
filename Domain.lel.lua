loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Adonis-Anticheat-Bypass-11111"))()
    
if (not LPH_OBFUSCATED) then
    LPH_NO_VIRTUALIZE = function(...) return (...) end;
    LPH_JIT_MAX = function(...) return (...) end;
    LPH_JIT_ULTRA = function(...) return (...) end;
end

  -- Serv
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    --// Variables
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace:FindFirstChildWhichIsA("Camera")
    local Hitsounds = {}

    --// Script Table
    local Script = {
        Functions = {},
        Locals = {
            Target = nil,
            IsTargetting = false,
            Resolver = {
                OldTick = tick(),
                OldPos = Vector3.new(0, 0, 0),
                ResolvedVelocity = Vector3.new(0, 0, 0)
            },
            AutoSelectTick = tick(),
            AntiAimViewer = {
                MouseRemoteFound = false,
                MouseRemote = nil,
                MouseRemoteArgs = nil,
                MouseRemotePositionIndex = nil
            },
            HitEffect = nil,
            Gun = {
                PreviousGun = nil,
                PreviousAmmo = 999,
                Shotguns = {"[Double-Barrel SG]", "[TacticalShotgun]", "[Shotgun]"}
            },
            JumpOffset = 0,
            BulletPath = {
                [4312377180] = Workspace:FindFirstChild("MAP") and Workspace.MAP:FindFirstChild("Ignored") or nil,
                [1008451066] = Workspace:FindFirstChild("Ignored") and Workspace.Ignored:FindFirstChild("Siren") and Workspace.Ignored.Siren:FindFirstChild("Radius") or nil,
                [3985694250] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
                [5106782457] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
                [4937639028] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
                [1958807588] = Workspace and Workspace:FindFirstChild("Ignored") or nil
            },
            World = {
                FogColor = Lighting.FogColor,
                FogStart = Lighting.FogStart,
                FogEnd = Lighting.FogEnd,
                Ambient = Lighting.Ambient,
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                ExposureCompensation = Lighting.ExposureCompensation
            },
            SavedCFrame = nil,
            NetworkPreviousTick = tick(),
            NetworkShouldSleep = false,
            OriginalVelocity = {},
            RotationAngle = 0
        },
        Utility = {
            Drawings = {},
            EspCache = {}
        },
        Connections = {
            GunConnections = {}
        },
        DomainIgnoreFolder = Instance.new("Folder", game:GetService("Workspace"))
    }

    --// Settings Table
    local Settings = {
        Combat = {
            Enabled = false,
            AimPart = "UpperTorso",
            Silent = false,
            Mouse = false,
            Alerts = false,
            LookAt = false,
            Spectate = false,
            AntiAimViewer = false,
            AutoSelect = {
                Enabled = false,
                Cooldown = {
                    Enabled = false,
                    Amount = 0.5
                }
            },
            Checks = {
                Enabled = false,
                Knocked = false,
                Crew = false,
                Wall = false,
                Grabbed = false,
                Vehicle = false
            },
            Smoothing = {
                Horizontal = 1,
                Vertical = 1
            },
            Prediction = {
                PredictionAmount = 0.160126357
            },
            Resolver = {
                Enabled = false,
                RefreshRate = 100
            },
            Fov = {
                Enabled = false,
                Visualize = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1)
                },
                Radius = 90
            },
            Visuals = {
                Enabled = false,
                Tracer = {
                    Enabled = false,
                    Color = Color3.new(255, 255, 15),
                    Thickness = 2
                },
                Dot = {
                    Enabled = false,
                    Color = Color3.new(255, 255, 255),
                    Filled = false,
                    Size = 5
                },
                Chams = {
                    Enabled = false,
                    Fill = {
                        Color = Color3.new(255, 154, 244),
                        Transparency = 0.5
                    },
                    Outline = {
                        Color = Color3.new(255, 154, 244),
                        Transparency = 0.5
                    }
                }
            },
            Air = {
                Enabled = false,
                AirAimPart = {
                    Enabled = false,
                    HitPart = "LowerTorso"
                },
                JumpOffset = {
                    Enabled = false,
                    Offset = 0.62
                }
            }
        },
        Visuals = {
            Esp = {
                Enabled = false,
                Boxes = {
                    Enabled = false,
                    Filled = {
                        Enabled = false,
                        Color = Color3.new(1, 1, 255),
                        Transparency = 0.3
                    },
                    Color = Color3.new(1, 1, 255)
                }
            },
            BulletTracers = {
                Enabled = false,
                Color = {
                    Gradient1 = Color3.new(255, 255, 255),
                    Gradient2 = Color3.new(255, 154, 244)
                },
                Duration = 1,
                Fade = {
                    Enabled = false,
                    Duration = 0.2
                }
            },
            BulletImpacts = {
                Enabled = false,
                Color = Color3.new(1, 1, 255),
                Duration = 1,
                Size = 1,
                Material = "SmoothPlastic",
                Fade = {
                    Enabled = false,
                    Duration = 0.5
                }
            },
            OnHit = {
                Enabled = false,
                Effect = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 255)
                },
                Sound = {
                    Enabled = false,
                    Volume = 5,
                    Value = "Skeet"
                },
                Chams = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 255),
                    Material = "ForceField",
                    Duration = 1
                }
            },
            World = {
                Enabled = false,
                Fog = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 255),
                    End = 1000,
                    Start = 10000
                },
                Ambient = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 255)
                },
                Brightness = {
                    Enabled = false,
                    Value = 0
                },
                ClockTime = {
                    Enabled = false,
                    Value = 24
                },
                WorldExposure = {
                    Enabled = false,
                    Value = -0.1
                }
            },
            Crosshair = {
                Enabled = false,
                Color = Color3.new(1, 1, 255),
                Size = 10,
                Gap = 2,
                Rotation = {
                    Enabled = false,
                    Speed = 1
                }
            }
        },
        AntiAim = {
            VelocitySpoofer = {
                Enabled = false,
                Visualize = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 255),
                    Prediction = 0.134
                },
                Type = "Underground",
                Roll = 0,
                Pitch = 0,
                Yaw = 0
            },
            CSync = {
                Enabled = false,
                Type = "TargetStrafe",
                Visualize = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 255)
                },
                RandomDistance = 0,
                Custom = {
                    X = 0,
                    Y = 0,
                    Z = 0
                },
                TargetStrafe = {
                    Speed = 20,
                    Distance = 13,
                    Height = 5
                }
            },
            Network = {
                Enabled = false,
                WalkingCheck = false,
                Amount = 0.1
            },
            VelocityDesync = {
                Enabled = false,
                Range = 5
            },
            FFlagDesync = {
                Enabled = false,
                SetNew = false,
                FFlags = {"S2PhysicsSenderRate"},
                SetNewAmount = 15,
                Amount = 2
            },
        },
        Misc = {
            Movement = {
                Speed = {
                    Enabled = false,
                    Amount = 1
                },
            },
            Exploits = {
                Enabled = false,
                NoRecoil = false,
                NoJumpCooldown = false,
                NoSlowDown = false
            }
        }
    }

    --// Functions
    do
        --// Utility Functions
        do
            Script.Functions.WorldToScreen = function(Position: Vector3)
                if not Position then return end

                local ViewportPointPosition, OnScreen = Camera:WorldToViewportPoint(Position)
                local ScreenPosition = Vector2.new(ViewportPointPosition.X, ViewportPointPosition.Y)
                return {
                    Position = ScreenPosition,
                    OnScreen = OnScreen
                }
            end

            Script.Functions.Connection = function(ConnectionType: any, Function: any)
                local Connection = ConnectionType:Connect(Function)
                return Connection
            end

            Script.Functions.MoveMouse = function(Position: Vector2, SmoothingX: number, SmoothingY: number)
                local MousePosition = UserInputService:GetMouseLocation()

                mousemoverel((Position.X - MousePosition.X) / SmoothingX, (Position.Y - MousePosition.Y) / SmoothingY)
            end

            Script.Functions.CreateDrawing = function(DrawingType: string, Properties: any)
                local DrawingObject = Drawing.new(DrawingType)

                for Property, Value in pairs(Properties) do
                    DrawingObject[Property] = Value
                end
                return DrawingObject
            end

            Script.Functions.WallCheck = function(Part: any)
                local RayCastParams = RaycastParams.new()
                RayCastParams.FilterType = Enum.RaycastFilterType.Exclude
                RayCastParams.IgnoreWater = true
                RayCastParams.FilterDescendantsInstances = Script.DomainIgnoreFolder:GetChildren()

                local CameraPosition = Camera.CFrame.Position
                local Direction = (Part.Position - CameraPosition).Unit
                local RayCastResult = workspace:Raycast(CameraPosition, Direction * 10000, RayCastParams)

                return RayCastResult.Instance and RayCastResult.Instance == Part
            end

            Script.Functions.Create = function(ObjectType: string, Properties: any)
                local Object = Instance.new(ObjectType)

                for Property, Value in pairs(Properties) do
                    Object[Property] = Value
                end
                return Object
            end

            Script.Functions.GetGun = function(Player: any)
                local Info = {
                    Tool = nil,
                    Ammo = nil,
                    IsGunEquipped = false
                }

                local Tool = Player.Character:FindFirstChildWhichIsA("Tool")

                if not Tool then return end

                if game.GameId == 1958807588 then
                    local ArmoryGun = Player.Information.Armory:FindFirstChild(Tool.Name)
                    if ArmoryGun then
                        Info.Tool = Tool
                        Info.Ammo = ArmoryGun.Ammo.Normal
                        Info.IsGunEquipped = true
                    else
                        for _, Object in pairs(Tool:GetChildren()) do
                            if Object.Name:lower():find("ammo") and not Object.Name:lower():find("max") then
                                Info.Tool = Tool
                                Info.IsGunEquipped = true
                                Info.Ammo = Object
                            end
                        end
                    end
                elseif game.GameId == 3634139746 then
                    for _, Object in pairs(Tool:getdescendants()) do
                        if Object.Name:lower():find("ammo") and not Object.Name:lower():find("max") and not Object.Name:lower():find("no") then
                            Info.Tool = Tool
                            Info.Ammo = Object
                            Info.IsGunEquipped = true
                        end
                    end
                else
                    for _, Object in pairs(Tool:GetChildren()) do
                        if Object.Name:lower():find("ammo") and not Object.Name:lower():find("max") then
                            Info.Tool = Tool
                            Info.IsGunEquipped = true
                            Info.Ammo = Object
                        end
                    end
                end


                return Info
            end

            Script.Functions.Beam = function(StartPos: Vector3, EndPos: Vector3)
                local ColorSequence = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Settings.Visuals.BulletTracers.Color.Gradient1),
                    ColorSequenceKeypoint.new(1, Settings.Visuals.BulletTracers.Color.Gradient2),
                })
                local Part = Instance.new("Part", Script.DomainIgnoreFolder)
                Part.Size = Vector3.new(0, 0, 0)
                Part.Massless = true
                Part.Transparency = 1
                Part.CanCollide = false
                Part.Position = StartPos
                Part.Anchored = true
                local Attachment = Instance.new("Attachment", Part)
                local Part2 = Instance.new("Part", Script.DomainIgnoreFolder)
                Part2.Size = Vector3.new(0, 0, 0)
                Part2.Transparency = 0
                Part2.CanCollide = false
                Part2.Position = EndPos
                Part2.Anchored = true
                Part2.Material = Enum.Material.ForceField
                Part2.Color = Color3.fromRGB(255, 0, 212)
                Part2.Massless = true
                local Attachment2 = Instance.new("Attachment", Part2)
                local Beam = Instance.new("Beam", Part)
                Beam.FaceCamera = true
                Beam.Color = ColorSequence
                Beam.Attachment0 = Attachment
                Beam.Attachment1 = Attachment2
                Beam.LightEmission = 6
                Beam.LightInfluence = 1
                Beam.Width0 = 1.5
                Beam.Width1 = 1.5
                Beam.Texture = "http://www.roblox.com/asset/?id=446111271"
                Beam.TextureSpeed = 2
                Beam.TextureLength = 1
                task.delay(Settings.Visuals.BulletTracers.Duration, function()
                    if Settings.Visuals.BulletTracers.Fade.Enabled then
                        local TweenValue = Instance.new("NumberValue")
                        TweenValue.Parent = Beam
                        local Tween = TweenService:Create(TweenValue, TweenInfo.new(Settings.Visuals.BulletTracers.Fade.Duration), {Value = 1})
                        Tween:Play()

                        local Connection
                        Connection = Script.Functions.Connection(TweenValue:GetPropertyChangedSignal("Value"), function()
                            Beam.Transparency = NumberSequence.new(TweenValue.Value, TweenValue.Value)
                        end)

                        Script.Functions.Connection(Tween.Completed, function()
                            Connection:Disconnect()
                            Part:Destroy()
                            Part2:Destroy()
                        end)
                    else
                        Part:Destroy()
                        Part2:Destroy()
                    end
                end)
            end

            Script.Functions.Impact = function(Pos: Vector3)
                local Part = Script.Functions.Create("Part", {
                    Parent = Script.DomainIgnoreFolder,
                    Color = Settings.Visuals.BulletImpacts.Color,
                    Size = Vector3.new(Settings.Visuals.BulletImpacts.Size, Settings.Visuals.BulletImpacts.Size, Settings.Visuals.BulletImpacts.Size),
                    Position = Pos,
                    Anchored = true,
                    Material = Enum.Material[Settings.Visuals.BulletImpacts.Material]
                })

                task.delay(Settings.Visuals.BulletImpacts.Duration, function()
                    if Settings.Visuals.BulletImpacts.Fade.Enabled then
                        local Tween = TweenService:Create(Part, TweenInfo.new(Settings.Visuals.BulletImpacts.Fade.Duration), {Transparency = 1})
                        Tween:Play()

                        Script.Functions.Connection(Tween.Completed, function()
                            Part:Destroy()
                        end)
                    else
                        Part:Destroy()
                    end
                end)
            end

            Script.Functions.GetClosestPlayerDamage = function(Position: Vector3, MaxRadius: number)
                local Radius = MaxRadius
                local ClosestPlayer

                for PlayerName, Health in pairs(Script.Locals.PlayerHealth) do
                    local Player = Players:FindFirstChild(PlayerName)
                    if Player and Player.Character then
                        local PlayerPosition = Player.Character.PrimaryPart.Position
                        local Distance = (Position - PlayerPosition).Magnitude
                        local CurrentHealth = Player.Character.Humanoid.Health
                        if (Distance < Radius) and (CurrentHealth < Health) then
                            Radius = Distance
                            ClosestPlayer = Player
                        end
                    end
                end
                return ClosestPlayer
            end


            Script.Functions.Effect = function(Part, Color)
                local Clone = Script.Locals.HitEffect:Clone()
                Clone.Parent = Part

                for _, Effect in pairs(Clone:GetChildren()) do
                    if Effect:IsA("ParticleEmitter") then
                        Effect.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                            ColorSequenceKeypoint.new(0.495, Settings.Visuals.OnHit.Effect.Color),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
                        })
                        Effect:Emit(1)
                    end
                end

                task.delay(2, function()
                    Clone:Destroy()
                end)
            end

            Script.Functions.PlaySound = function(SoundId, Volume)
                local Sound = Instance.new("Sound")
                Sound.Parent = Script.DomainIgnoreFolder
                Sound.Volume = Volume
                Sound.SoundId = SoundId

                Sound:Play()

                Script.Functions.Connection(Sound.Ended, function()
                    Sound:Destroy()
                end)
            end

            Script.Functions.Hitcham = function(Player, Color)
                for _, BodyPart in pairs(Player.Character:GetChildren()) do
                    if BodyPart.Name ~= "HumanoidRootPart" and BodyPart:IsA("BasePart") then
                        local Part = Instance.new("Part")
                        Part.Name = BodyPart.Name .. "_Clone"
                        Part.Parent = Script.DomainIgnoreFolder
                        Part.Material = Enum.Material[Settings.Visuals.OnHit.Chams.Material]
                        Part.Color = Settings.Visuals.OnHit.Chams.Color
                        Part.Transparency = 0
                        Part.Anchored = true
                        Part.Size = BodyPart.Size
                        Part.CFrame = BodyPart.CFrame

                        task.delay(Settings.Visuals.OnHit.Chams.Duration, function()
                            Part:Destroy()
                        end)
                    end
                end
            end

            Script.Functions.Rotate = function(Vector, Origin, Angle)
                local CosA = math.cos(Angle)
                local SinA = math.sin(Angle)
                local X = Vector.X - Origin.X
                local Y = Vector.Y - Origin.Y
                local NewX = X * CosA - Y * SinA
                local NewY = X * SinA + Y * CosA
                return Vector2.new(NewX + Origin.x, NewY + Origin.y)
            end
        end

        --// General Functions
        do
            Script.Functions.GetClosestPlayer = function()
                local Radius = Settings.Combat.Fov.Enabled and Settings.Combat.Fov.Radius or math.huge
                local ClosestPlayer
                local Mouse = UserInputService:GetMouseLocation()

                for _, Player in pairs(Players:GetPlayers()) do
                    if Player ~= LocalPlayer then
                        --// Variables
                        local ScreenPosition = Script.Functions.WorldToScreen(Player.Character.PrimaryPart.Position)
                        local Distance = (Mouse - ScreenPosition.Position).Magnitude

                        --// OnScreen Check
                        if not ScreenPosition.OnScreen then continue end

                        --// Checks
                        if (Settings.Combat.Checks.Enabled and (Settings.Combat.Checks.Vehicle and Player.Character:FindFirstChild("[CarHitBox]")) or (Settings.Combat.Checks.Knocked and Player.Character.BodyEffects["K.O"].Value == true) or (Settings.Combat.Checks.Grabbed and Player.Character:FindFirstChild("GRABBING_CONSTRAINT")) or (Settings.Combat.Checks.Crew and Player.DataFolder.Information.Crew.Value == LocalPlayer.DataFolder.Information.Crew.Value) or (Settings.Combat.Checks.Wall and Script.Functions.WallCheck(Player.Character.PrimaryPart))) then continue end

                        if (Distance < Radius) then
                            Radius = Distance
                            ClosestPlayer = Player
                        end
                    end
                end

                return ClosestPlayer
            end

            Script.Functions.GetPredictedPosition = function()
                local BodyPart = Script.Locals.Target.Character[Settings.Combat.AimPart]
                local Velocity = Settings.Combat.Resolver.Enabled and Script.Locals.Resolver.ResolvedVelocity or Script.Locals.Target.Character.HumanoidRootPart.Velocity
                local Position = BodyPart.Position + Velocity * Vector3.new(Settings.Combat.Prediction.PredictionAmount, Settings.Combat.Prediction.PredictionAmount, Settings.Combat.Prediction.PredictionAmount)

                if Settings.Combat.Air.Enabled and Settings.Combat.Air.JumpOffset.Enabled then
                    Position = Position + Vector3.new(0, Script.Locals.JumpOffset, 0)
                end

                return Position
            end

            Script.Functions.Resolve = function()
                if Settings.Combat.Enabled and Settings.Combat.Resolver.Enabled and Script.Locals.IsTargetting and Script.Locals.Target then
                    --// Variables
                    local HumanoidRootPart = Script.Locals.Target.Character.HumanoidRootPart
                    local CurrentPosition = HumanoidRootPart.Position
                    local DeltaTime = tick() - Script.Locals.Resolver.OldTick
                    local NewVelocity = (CurrentPosition - Script.Locals.Resolver.OldPos) / DeltaTime

                    --// Set the velocity
                    Script.Locals.Resolver.ResolvedVelocity = NewVelocity

                    --// Update the old tick and old position
                    if tick() - Script.Locals.Resolver.OldTick >= 1 / Settings.Combat.Resolver.RefreshRate then
                        Script.Locals.Resolver.OldTick, Script.Locals.Resolver.OldPos = tick(), HumanoidRootPart.Position
                    end
                end
            end

            Script.Functions.MouseAim = function()
                if Settings.Combat.Enabled and Settings.Combat.Mouse and Script.Locals.IsTargetting and Script.Locals.Target then
                    local Position = Script.Functions.GetPredictedPosition()
                    local ScreenPosition = Script.Functions.WorldToScreen(Position)

                    if ScreenPosition.OnScreen then
                        Script.Functions.MoveMouse(ScreenPosition.Position, Settings.Combat.Smoothing.Horizontal, Settings.Combat.Smoothing.Vertical)
                    end
                end
            end

            Script.Functions.UpdateFieldOfView = function()
                Script.Utility.Drawings["FieldOfViewVisualizer"].Visible = Settings.Combat.Enabled and Settings.Combat.Fov.Enabled and Settings.Combat.Fov.Visualize.Enabled
                Script.Utility.Drawings["FieldOfViewVisualizer"].Color = Settings.Combat.Fov.Visualize.Color
                Script.Utility.Drawings["FieldOfViewVisualizer"].Radius = Settings.Combat.Fov.Radius
                Script.Utility.Drawings["FieldOfViewVisualizer"].Position = UserInputService:GetMouseLocation()
            end

            Script.Functions.UpdateTargetVisuals = function()
                --// ScreenPosition, Will be changed later
                local Position

                --// Variable to indicate if you"re targetting or not with a check if the target visuals are enabled
                local IsTargetting = Settings.Combat.Enabled and Settings.Combat.Visuals.Enabled and Script.Locals.IsTargetting and Script.Locals.Target or false

                --// Change the position
                if IsTargetting then
                    local PredictedPosition = Script.Functions.GetPredictedPosition()
                    Position = Script.Functions.WorldToScreen(PredictedPosition)
                end

                --// Variable to indicate if the drawing elements should show
                local TracerShow = IsTargetting and Settings.Combat.Visuals.Tracer.Enabled and Position.OnScreen or false
                local DotShow = IsTargetting and Settings.Combat.Visuals.Dot.Enabled and Position.OnScreen or false
                local ChamsShow = IsTargetting and Settings.Combat.Visuals.Chams.Enabled and Script.Locals.Target and Script.Locals.Target.Character or nil


                --// Set the drawing elements visibility
                Script.Utility.Drawings["TargetTracer"].Visible = TracerShow
                Script.Utility.Drawings["TargetDot"].Visible = DotShow
                Script.Utility.Drawings["TargetChams"].Parent = ChamsShow


                --// Update the drawing elements
                if TracerShow then
                    Script.Utility.Drawings["TargetTracer"].From = UserInputService:GetMouseLocation()
                    Script.Utility.Drawings["TargetTracer"].To = Position.Position
                    Script.Utility.Drawings["TargetTracer"].Color = Settings.Combat.Visuals.Tracer.Color
                    Script.Utility.Drawings["TargetTracer"].Thickness = Settings.Combat.Visuals.Tracer.Thickness
                end

                if DotShow then
                    Script.Utility.Drawings["TargetDot"].Position = Position.Position
                    Script.Utility.Drawings["TargetDot"].Radius = Settings.Combat.Visuals.Dot.Size
                    Script.Utility.Drawings["TargetDot"].Filled = Settings.Combat.Visuals.Dot.Filled
                    Script.Utility.Drawings["TargetDot"].Color = Settings.Combat.Visuals.Dot.Color
                end

                if ChamsShow then
                    Script.Utility.Drawings["TargetChams"].FillColor = Settings.Combat.Visuals.Chams.Fill.Color
                    Script.Utility.Drawings["TargetChams"].FillTransparency = Settings.Combat.Visuals.Chams.Fill.Transparency
                    Script.Utility.Drawings["TargetChams"].OutlineTransparency = Settings.Combat.Visuals.Chams.Outline.Transparency
                    Script.Utility.Drawings["TargetChams"].OutlineColor = Settings.Combat.Visuals.Chams.Outline.Color
                end
            end

            Script.Functions.AutoSelect = function()
                if (Settings.Combat.Enabled and Settings.Combat.AutoSelect.Enabled) and (tick() - Script.Locals.AutoSelectTick >= Settings.Combat.AutoSelect.Cooldown.Amount and Settings.Combat.AutoSelect.Cooldown.Enabled or true) then
                    local NewTarget = Script.Functions.GetClosestPlayer()
                    Script.Locals.Target = NewTarget or nil
                    Script.Locals.IsTargetting =  NewTarget and true or false
                    Script.Locals.AutoSelectTick = tick()
                end
            end

            Script.Functions.GunEvents = function()
                local CurrentGun = Script.Functions.GetGun(LocalPlayer)

                if CurrentGun and CurrentGun.IsGunEquipped and CurrentGun.Tool then
                    if CurrentGun.Tool ~= Script.Locals.Gun.PreviousGun then
                        Script.Locals.Gun.PreviousGun = CurrentGun.Tool
                        Script.Locals.Gun.PreviousAmmo = 999

                        --// Connections
                        for _, Connection in pairs(Script.Connections.GunConnections) do
                            Connection:Disconnect()
                        end
                        Script.Connections.GunConnections = {}
                    end

                    if not Script.Connections.GunConnections["GunActivated"] and Settings.Combat.Enabled and Settings.Combat.Silent and Script.Locals.AntiAimViewer.MouseRemoteFound then
                        Script.Connections.GunConnections["GunActivated"] = Script.Functions.Connection(CurrentGun.Tool.Activated, function()
                            if Script.Locals.IsTargetting and Script.Locals.Target then
                                if Settings.Combat.AntiAimViewer then
                                    local Arguments = Script.Locals.AntiAimViewer.MouseRemoteArgs

                                    Arguments[Script.Locals.AntiAimViewer.MouseRemotePositionIndex] = Script.Functions.GetPredictedPosition()
                                    Script.Locals.AntiAimViewer.MouseRemote:FireServer(unpack(Arguments))
                                end
                            end
                        end)
                    end


                    if not Script.Connections.GunConnections["GunAmmoChanged"] then
                        Script.Connections.GunConnections["GunAmmoChanged"] = Script.Functions.Connection(CurrentGun.Ammo:GetPropertyChangedSignal("Value") , function()
                            local NewAmmo = CurrentGun.Ammo.Value
                            if (NewAmmo < Script.Locals.Gun.PreviousAmmo or (game.GameId == 3985694250 and NewAmmo > Script.Locals.Gun.PreviousAmmo)) and Script.Locals.Gun.PreviousAmmo then

                                local ChildAdded
                                local ChildrenAdded = 0
                                ChildAdded = Script.Functions.Connection(Script.Locals.BulletPath[game.GameId].ChildAdded, function(Object)
                                    if Object.Name == "BULLET_RAYS" then
                                        ChildrenAdded += 1
                                        if (table.find(Script.Locals.Gun.Shotguns, CurrentGun.Tool.Name) and ChildrenAdded <= 5) or (ChildrenAdded == 1) then
                                            local GunBeam = Object:WaitForChild("GunBeam")
                                            local StartPos, EndPos = Object.Position, GunBeam.Attachment1.WorldPosition

                                            if Settings.Visuals.BulletTracers.Enabled then
                                                GunBeam:Destroy()
                                                Script.Functions.Beam(StartPos, EndPos)
                                            end

                                            if Settings.Visuals.BulletImpacts.Enabled then
                                                Script.Functions.Impact(EndPos)
                                            end

                                            if Settings.Visuals.OnHit.Enabled then
                                                local Player = Script.Functions.GetClosestPlayerDamage(EndPos, 20)
                                                if Player then
                                                    if Settings.Visuals.OnHit.Effect.Enabled then
                                                        Script.Functions.Effect(Player.Character.HumanoidRootPart)
                                                    end

                                                    if Settings.Visuals.OnHit.Sound.Enabled then
                                                        local Sound = string.format("hitsounds/%s", Settings.Visuals.OnHit.Sound.Value)
                                                        Script.Functions.PlaySound(getcustomasset(Sound), Settings.Visuals.OnHit.Sound.Volume)
                                                    end

                                                    if Settings.Visuals.OnHit.Chams.Enabled then
                                                        Script.Functions.Hitcham(Player, Settings.Visuals.OnHit.Chams.Color)
                                                    end
                                                end
                                            end
                                            ChildAdded:Disconnect()
                                        end
                                    else
                                        ChildAdded:Disconnect()
                                    end
                                end)
                            end
                            Script.Locals.Gun.PreviousAmmo = NewAmmo
                        end)
                    end
                end
            end

            Script.Functions.Air = function()
                if Settings.Combat.Enabled and Script.Locals.IsTargetting and Script.Locals.Target and Settings.Combat.Air.Enabled then
                    local Humanoid = Script.Locals.Target.Character.Humanoid

                    if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                        Script.Locals.JumpOffset = Settings.Combat.Air.JumpOffset.Offset
                    else
                        Script.Locals.JumpOffset = 0
                    end
                end
            end

            Script.Functions.UpdateHealth = function()
                if Settings.Visuals.OnHit.Enabled then
                    for _, Player in pairs(Players:GetPlayers()) do
                        if Player.Character and Player.Character.Humanoid then
                            Script.Locals.PlayerHealth[Player.Name] = Player.Character.Humanoid.Health
                        end
                    end
                end
            end

            Script.Functions.UpdateAtmosphere = function()
                Lighting.FogColor = Settings.Visuals.World.Enabled and Settings.Visuals.World.Fog.Enabled and Settings.Visuals.World.Fog.Color or Script.Locals.World.FogColor
                Lighting.FogStart = Settings.Visuals.World.Enabled and Settings.Visuals.World.Fog.Enabled and Settings.Visuals.World.Fog.Start or Script.Locals.World.FogStart
                Lighting.FogEnd = Settings.Visuals.World.Enabled and Settings.Visuals.World.Fog.Enabled and Settings.Visuals.World.Fog.End or Script.Locals.World.FogEnd
                Lighting.Ambient = Settings.Visuals.World.Enabled and Settings.Visuals.World.Ambient.Enabled and Settings.Visuals.World.Ambient.Color or Script.Locals.World.Ambient
                Lighting.Brightness = Settings.Visuals.World.Enabled and Settings.Visuals.World.Brightness.Enabled and Settings.Visuals.World.Brightness.Value or Script.Locals.World.Brightness
                Lighting.ClockTime = Settings.Visuals.World.Enabled and Settings.Visuals.World.ClockTime.Enabled and Settings.Visuals.World.ClockTime.Value or Script.Locals.World.ClockTime
                Lighting.ExposureCompensation = Settings.Visuals.World.Enabled and Settings.Visuals.World.WorldExposure.Enabled and Settings.Visuals.World.WorldExposure.Value or Script.Locals.World.ExposureCompensation
            end

            Script.Functions.VelocitySpoof = function()
                local ShowVisualizerDot = Settings.AntiAim.VelocitySpoofer.Enabled and Settings.AntiAim.VelocitySpoofer.Visualize.Enabled

                Script.Utility.Drawings["VelocityDot"].Visible = ShowVisualizerDot


                if Settings.AntiAim.VelocitySpoofer.Enabled then
                    --// Variables
                    local Type = Settings.AntiAim.VelocitySpoofer.Type
                    local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                    local Velocity = HumanoidRootPart.Velocity

                    --// Main
                    if Type == "Underground" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, -Settings.AntiAim.VelocitySpoofer.Yaw, 0)
                    elseif Type == "Sky" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, Settings.AntiAim.VelocitySpoofer.Yaw, 0)
                    elseif Type == "Multiplier" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(Settings.AntiAim.VelocitySpoofer.Yaw, Settings.AntiAim.VelocitySpoofer.Pitch, Settings.AntiAim.VelocitySpoofer.Roll)
                    elseif Type == "Custom" then
                        HumanoidRootPart.Velocity = Vector3.new(Settings.AntiAim.VelocitySpoofer.Yaw, Settings.AntiAim.VelocitySpoofer.Pitch, Settings.AntiAim.VelocitySpoofer.Roll)
                    elseif Type == "Prediction Breaker" then
                        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end

                    if ShowVisualizerDot then
                        local ScreenPosition = Script.Functions.WorldToScreen(LocalPlayer.Character.HumanoidRootPart.Position + LocalPlayer.Character.HumanoidRootPart.Velocity * Settings.AntiAim.VelocitySpoofer.Visualize.Prediction)

                        Script.Utility.Drawings["VelocityDot"].Position = ScreenPosition.Position
                        Script.Utility.Drawings["VelocityDot"].Color = Settings.AntiAim.VelocitySpoofer.Visualize.Color
                    end

                    RunService.RenderStepped:Wait()
                    HumanoidRootPart.Velocity = Velocity
                end
            end

            Script.Functions.CSync = function()
                Script.Utility.Drawings["CFrameVisualize"].Parent = Settings.AntiAim.CSync.Visualize.Enabled and Settings.AntiAim.CSync.Enabled and Script.DomainIgnoreFolder or nil

                if Settings.AntiAim.CSync.Enabled then
                    local Type = Settings.AntiAim.CSync.Type
                    local FakeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    Script.Locals.SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    if Type == "Custom" then
                        FakeCFrame = FakeCFrame * CFrame.new(Settings.AntiAim.CSync.Custom.X, Settings.AntiAim.CSync.Custom.Y, Settings.AntiAim.CSync.Custom.Z)
                    elseif Type == "Target Strafe" and Script.Locals.IsTargetting and Script.Locals.Target and Settings.Combat.Enabled then
                        local CurrentTime = tick()
                        FakeCFrame = CFrame.new(Script.Locals.Target.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * CurrentTime * Settings.AntiAim.CSync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, Settings.AntiAim.CSync.TargetStrafe.Height, Settings.AntiAim.CSync.TargetStrafe.Distance)
                    elseif Type == "Local Strafe" then
                        local CurrentTime = tick()
                        FakeCFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * CurrentTime * Settings.AntiAim.CSync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, Settings.AntiAim.CSync.TargetStrafe.Height, Settings.AntiAim.CSync.TargetStrafe.Distance)
                    elseif Type == "Random" then
                        FakeCFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance))) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
                      elseif Type == "KillCheaters" then
                        FakeCFrame = FakeCFrame * CFrame.new(9e9, math.huge, 0/0)
                    elseif Type == "Random Target" and Script.Locals.IsTargetting and Script.Locals.Target and Settings.Combat.Enabled then
                        FakeCFrame = CFrame.new(Script.Locals.Target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance))) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
                      elseif Type == "Test" and Script.Locals.IsTargetting and Script.Locals.Target and Settings.Combat.Enabled then
                        FakeCFrame = CFrame.new(Script.Locals.Target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10, 10), 0, math.random(-15, 15))) * CFrame.Angles(math.rad(math.random(-180, 20)), math.rad(math.random(-10, 500)), math.rad(math.random(0, 100)))
                    elseif Type == "BoxRandom" and Script.Locals.IsTargetting and Script.Locals.Target and Settings.Combat.Enabled then
                      FakeCFrame = CFrame.new(Script.Locals.Target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance))) * CFrame.Angles(0, 0, 0)
                    end

                    Script.Utility.Drawings["CFrameVisualize"]:SetPrimaryPartCFrame(FakeCFrame)

                    for _, Part in pairs(Script.Utility.Drawings["CFrameVisualize"]:GetChildren()) do
                        Part.Color = Settings.AntiAim.CSync.Visualize.Color
                    end

                    LocalPlayer.Character.HumanoidRootPart.CFrame = FakeCFrame
                    RunService.RenderStepped:Wait()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Script.Locals.SavedCFrame
                end
            end

            Script.Functions.Network = function()
                if Settings.AntiAim.Network.Enabled then
                    if (tick() - Script.Locals.NetworkPreviousTick) >= ((Settings.AntiAim.Network.Amount / math.pi) / 10000) or (Settings.AntiAim.Network.WalkingCheck and LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0) then
                        Script.Locals.NetworkShouldSleep = not Script.Locals.NetworkShouldSleep
                        Script.Locals.NetworkPreviousTick = tick()
                        sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", Script.Locals.NetworkShouldSleep)
                    end
                end
            end

            Script.Functions.Speed = function()
                if Settings.Misc.Movement.Speed.Enabled then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * Settings.Misc.Movement.Speed.Amount
                end
            end

            Script.Functions.VelocityDesync = function()
                if Settings.AntiAim.VelocityDesync.Enabled then
                    local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                    local Velocity = HumanoidRootPart.Velocity
                    local Amount = Settings.AntiAim.VelocityDesync.Range * 1000
                    HumanoidRootPart.Velocity = Vector3.new(math.random(-Amount, Amount), math.random(-Amount, Amount), math.random(-Amount, Amount))
                    RunService.RenderStepped:Wait()
                    HumanoidRootPart.Velocity = Velocity
                end
            end

            Script.Functions.FFlagDesync = function()
                if Settings.AntiAim.FFlagDesync.Enabled then
                    for FFlag, _ in pairs(Settings.AntiAim.FFlagDesync.FFlags) do
                        local Value = Settings.AntiAim.FFlagDesync.Amount
                        setfflag(FFlag, tostring(Value))

                        RunService.RenderStepped:Wait()
                        if Settings.AntiAim.FFlagDesync.SetNew then
                            setfflag(FFlag, Settings.AntiAim.FFlagDesync.SetNewAmount)
                        end
                    end
                end
            end


            --// Invisible Desync

            Script.Functions.NoSlowdown = function()
                if Settings.Misc.Exploits.NoSlowDown then
                    for _, Slowdown in pairs(LocalPlayer.Character.BodyEffects.Movement:GetChildren()) do
                        Slowdown:Destroy()
                    end
                end
            end

            --// Horrid code
            Script.Functions.UpdateCrosshair = function()
                if Settings.Visuals.Crosshair.Enabled then
                    local MouseX, MouseY
                    local RotationAngle = Script.Locals.RotationAngle
                    local RealSize = Settings.Visuals.Crosshair.Size * 2

                    if not MouseX or not MouseY then
                        MouseX, MouseY = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
                    end

                    local Gap = Settings.Visuals.Crosshair.Gap
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Locals.RotationAngle = Script.Locals.RotationAngle + Settings.Visuals.Crosshair.Rotation.Speed
                    else
                        Script.Locals.RotationAngle = 0
                    end

                    Script.Utility.Drawings["CrosshairLeft"].Visible = true
                    Script.Utility.Drawings["CrosshairLeft"].Color = Settings.Visuals.Crosshair.Color
                    Script.Utility.Drawings["CrosshairLeft"].Thickness = 1
                    Script.Utility.Drawings["CrosshairLeft"].Transparency = 1
                    Script.Utility.Drawings["CrosshairLeft"].From = Vector2.new(MouseX + Gap, MouseY)
                    Script.Utility.Drawings["CrosshairLeft"].To = Vector2.new(MouseX + RealSize, MouseY)
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Utility.Drawings["CrosshairLeft"].From = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairLeft"].From, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                        Script.Utility.Drawings["CrosshairLeft"].To = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairLeft"].To, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                    end

                    Script.Utility.Drawings["CrosshairRight"].Visible = true
                    Script.Utility.Drawings["CrosshairRight"].Color = Settings.Visuals.Crosshair.Color
                    Script.Utility.Drawings["CrosshairRight"].Thickness = 1
                    Script.Utility.Drawings["CrosshairRight"].Transparency = 1
                    Script.Utility.Drawings["CrosshairRight"].From = Vector2.new(MouseX - Gap, MouseY)
                    Script.Utility.Drawings["CrosshairRight"].To = Vector2.new(MouseX - RealSize, MouseY)
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Utility.Drawings["CrosshairRight"].From = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairRight"].From, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                        Script.Utility.Drawings["CrosshairRight"].To = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairRight"].To, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                    end

                    Script.Utility.Drawings["CrosshairTop"].Visible = true
                    Script.Utility.Drawings["CrosshairTop"].Color = Settings.Visuals.Crosshair.Color
                    Script.Utility.Drawings["CrosshairTop"].Thickness = 1
                    Script.Utility.Drawings["CrosshairTop"].Transparency = 1
                    Script.Utility.Drawings["CrosshairTop"].From = Vector2.new(MouseX, MouseY + Gap)
                    Script.Utility.Drawings["CrosshairTop"].To = Vector2.new(MouseX, MouseY + RealSize)
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Utility.Drawings["CrosshairTop"].From = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairTop"].From, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                        Script.Utility.Drawings["CrosshairTop"].To = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairTop"].To, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                    end

                    Script.Utility.Drawings["CrosshairBottom"].Visible = true
                    Script.Utility.Drawings["CrosshairBottom"].Color = Settings.Visuals.Crosshair.Color
                    Script.Utility.Drawings["CrosshairBottom"].Thickness = 1
                    Script.Utility.Drawings["CrosshairBottom"].Transparency = 1
                    Script.Utility.Drawings["CrosshairBottom"].From = Vector2.new(MouseX, MouseY - Gap)
                    Script.Utility.Drawings["CrosshairBottom"].To = Vector2.new(MouseX, MouseY - RealSize)
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Utility.Drawings["CrosshairBottom"].From = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairBottom"].From, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                        Script.Utility.Drawings["CrosshairBottom"].To = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairBottom"].To, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                    end
                else
                    Script.Utility.Drawings["CrosshairBottom"].Visible = false
                    Script.Utility.Drawings["CrosshairTop"].Visible = false
                    Script.Utility.Drawings["CrosshairRight"].Visible = false
                    Script.Utility.Drawings["CrosshairLeft"].Visible = false
                end
            end

            Script.Functions.UpdateLookAt = function()
                if Settings.Combat.Enabled and Settings.Combat.LookAt and Script.Locals.IsTargetting and Script.Locals.Target then
                    LocalPlayer.Character.Humanoid.AutoRotate = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position, Vector3.new(Script.Locals.Target.Character.HumanoidRootPart.CFrame.X, LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Y, Script.Locals.Target.Character.HumanoidRootPart.CFrame.Z))
                else
                    LocalPlayer.Character.Humanoid.AutoRotate = true
                end
            end

            Script.Functions.UpdateSpectate = function()
                if Settings.Combat.Enabled and Settings.Combat.Spectate and Script.Locals.IsTargetting and Script.Locals.Target then
                    Camera.CameraSubject = Script.Locals.Target.Character.Humanoid
                else
                    Camera.CameraSubject = LocalPlayer.Character.Humanoid
                end
            end
        end

        --// Esp Function
        do

        end
    end

    --// Drawing objects
    do
        Script.Utility.Drawings["FieldOfViewVisualizer"] = Script.Functions.CreateDrawing("Circle", {
            Visible = Settings.Combat.Fov.Visualize.Enabled,
            Color = Settings.Combat.Fov.Visualize.Color,
            Radius = Settings.Combat.Fov.Radius
        })

        Script.Utility.Drawings["TargetTracer"] = Script.Functions.CreateDrawing("Line",{
            Visible = false,
            Color = Settings.Combat.Visuals.Tracer.Color,
            Thickness = Settings.Combat.Visuals.Tracer.Thickness
        })

        Script.Utility.Drawings["TargetDot"] = Script.Functions.CreateDrawing("Circle", {
            Visible = false,
            Color = Settings.Combat.Visuals.Dot.Color,
            Radius = Settings.Combat.Visuals.Dot.Size
        })

        Script.Utility.Drawings["VelocityDot"] = Script.Functions.CreateDrawing("Circle", {
            Visible = false,
            Color = Settings.AntiAim.VelocitySpoofer.Visualize.Color,
            Radius = 6,
            Filled = true
        })

        Script.Utility.Drawings["TargetChams"] = Script.Functions.Create("Highlight", {
            Parent = nil,
            FillColor = Settings.Combat.Visuals.Chams.Fill.Color,
            FillTransparency = Settings.Combat.Visuals.Chams.Fill.Transparency,
            OutlineColor = Settings.Combat.Visuals.Chams.Fill.Color,
            OutlineTransparency = Settings.Combat.Visuals.Chams.Outline.Transparency
        })

        Script.Utility.Drawings["CrosshairTop"] = Script.Functions.CreateDrawing("Line", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
            ZIndex = 10000
        })

        Script.Utility.Drawings["CrosshairBottom"] = Script.Functions.CreateDrawing("Line", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
            ZIndex = 10000
        })

        Script.Utility.Drawings["CrosshairLeft"] = Script.Functions.CreateDrawing("Line", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
            ZIndex = 10000
        })

        Script.Utility.Drawings["CrosshairRight"] = Script.Functions.CreateDrawing("Line", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
            ZIndex = 10000
        })


        Script.Utility.Drawings["CFrameVisualize"] = game:GetObjects("rbxassetid://9474737816")[1]; Script.Utility.Drawings["CFrameVisualize"].Head.Face:Destroy(); for _, v in pairs(Script.Utility.Drawings["CFrameVisualize"]:GetChildren()) do v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70; v.Material = "Neon"; v.Color = Settings.AntiAim.CSync.Visualize.Color; v.CanCollide = false; v.Anchored = false end
    end


    --// Hitsounds
    do
        --// Hitsounds
        Hitsounds = {
            ["bell.wav"] = "https://github.com/Sigma-3131/HitSounds/raw/main/bell.wav",
            ["bepis.wav"] = "https://github.com/Sigma-3131/HitSounds/raw/main/bepis.wav",
            ["bubble.wav"] = "https://github.com/Sigma-3131/HitSounds/raw/main/bubble.wav",
            ["cock.wav"] = "https://github.com/Sigma-3131/HitSounds/raw/main/cock.wav",
            ["cod.wav"] = "https://github.com/Sigma-3131/HitSounds/raw/main/cod.wav",
            ["fatality.wav"] = "https://github.com/Sigma-3131/HitSounds/raw/main/fatality.wav",
            ["phonk.wav"] = "https://github.com/Sigma-3131/HitSounds/raw/main/phonk.wav",
            ["sparkle.wav"] = "https://github.com/Sigma-3131/HitSounds/raw/main/sparkle.wav",
        }

        if not isfolder("hitsounds") then
            makefolder("hitsounds")
        end

        for Name, Url in pairs(Hitsounds) do
            local Path = "hitsounds" .. "/" .. Name
            if not isfile(Path) then
                writefile(Path, game:HttpGet(Url))
            end
        end
    end

    --// Hit Effects
    do
        --// Nova
        do
            local Part = Instance.new("Part")
            Part.Parent = ReplicatedStorage

            local Attachment = Instance.new("Attachment")
            Attachment.Name = "Attachment"
            Attachment.Parent = Part

            Script.Locals.HitEffect = Attachment

            local ParticleEmitter = Instance.new("ParticleEmitter")
            ParticleEmitter.Name = "ParticleEmitter"
            ParticleEmitter.Acceleration = Vector3.new(0, 0, 1)
            ParticleEmitter.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.495, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            })
            ParticleEmitter.Lifetime = NumberRange.new(0.5, 0.5)
            ParticleEmitter.LightEmission = 1
            ParticleEmitter.LockedToPart = true
            ParticleEmitter.Rate = 1
            ParticleEmitter.Rotation = NumberRange.new(0, 360)
            ParticleEmitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 10),
                NumberSequenceKeypoint.new(1, 1),
            })
            ParticleEmitter.Speed = NumberRange.new(0, 0)
            ParticleEmitter.Texture = "rbxassetid://1084991215"
            ParticleEmitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.534, 0.25),
                NumberSequenceKeypoint.new(1, 0.5),
                NumberSequenceKeypoint.new(1, 0),
            })
            ParticleEmitter.ZOffset = 1
            ParticleEmitter.Parent = Attachment
            local ParticleEmitter1 = Instance.new("ParticleEmitter")
            ParticleEmitter1.Name = "ParticleEmitter"
            ParticleEmitter1.Acceleration = Vector3.new(0, 1, -0.001)
            ParticleEmitter1.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.495, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            })
            ParticleEmitter1.Lifetime = NumberRange.new(0.5, 0.5)
            ParticleEmitter1.LightEmission = 1
            ParticleEmitter1.LockedToPart = true
            ParticleEmitter1.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            ParticleEmitter1.Rate = 1
            ParticleEmitter1.Rotation = NumberRange.new(0, 360)
            ParticleEmitter1.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 10),
                NumberSequenceKeypoint.new(1, 1),
            })
            ParticleEmitter1.Speed = NumberRange.new(0, 0)
            ParticleEmitter1.Texture = "rbxassetid://1084991215"
            ParticleEmitter1.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.534, 0.25),
                NumberSequenceKeypoint.new(1, 0.5),
                NumberSequenceKeypoint.new(1, 0),
            })
            ParticleEmitter1.ZOffset = 1
            ParticleEmitter1.Parent = Attachment
        end
    end

    --// Connections
    do
        --// Combat Connections
        do
            Script.Functions.Connection(RunService.Heartbeat, function()
                Script.Functions.MouseAim()

                Script.Functions.Resolve()

                Script.Functions.Air()

                Script.Functions.UpdateLookAt()
            end)

            Script.Functions.Connection(RunService.RenderStepped, function()
                Script.Functions.UpdateFieldOfView()

                Script.Functions.UpdateTargetVisuals()

                Script.Functions.AutoSelect()

                Script.Functions.UpdateSpectate()
            end)
        end

        --// Visual Connections
        do
            Script.Functions.Connection(RunService.RenderStepped, function()
                Script.Functions.GunEvents()

                Script.Functions.UpdateHealth()

                Script.Functions.UpdateAtmosphere()

                Script.Functions.UpdateCrosshair()
            end)
        end

        --// Anti Aim Connection
        do
            Script.Functions.Connection(RunService.Heartbeat, function()
                Script.Functions.VelocitySpoof()

                Script.Functions.CSync()

                Script.Functions.Network()

                Script.Functions.VelocityDesync()

                Script.Functions.FFlagDesync()
            end)
        end

        --// Movement Connections
        do
            Script.Functions.Connection(RunService.Heartbeat, function()
                Script.Functions.Speed()

                Script.Functions.NoSlowdown()
            end)
        end
    end

    --// Hooks
    do
        local __namecall
        local __newindex
        local __index

        __index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(Self, Index)
            if not checkcaller() and Settings.AntiAim.CSync.Enabled and Script.Locals.SavedCFrame and Index == "CFrame" and Self == LocalPlayer.Character.HumanoidRootPart then
                return Script.Locals.SavedCFrame
            end
            return __index(Self, Index)
        end))

        __namecall = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(Self, ...)
            local Arguments = {...}
            local Method = tostring(getnamecallmethod())

            if not checkcaller() and Method == "FireServer" then
                for _, Argument in pairs(Arguments) do
                    if typeof(Argument) == "Vector3" then
                        Script.Locals.AntiAimViewer.MouseRemote = Self
                        Script.Locals.AntiAimViewer.MouseRemoteFound = true
                        Script.Locals.AntiAimViewer.MouseRemoteArgs = Arguments
                        Script.Locals.AntiAimViewer.MouseRemotePositionIndex = _

                        if Settings.Combat.Enabled and Settings.Combat.Silent and not Settings.Combat.AntiAimViewer and Script.Locals.IsTargetting and Script.Locals.Target then
                            Arguments[_] =  Script.Functions.GetPredictedPosition()
                        end

                        return __namecall(Self, unpack(Arguments))
                    end
                end
            end
            return __namecall(Self, ...)
        end))

        __newindex = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(Self, Property, Value)
            local CallingScript = getcallingscript()


            --// Atmosphere caching
            if not checkcaller() and Self == Lighting and Script.Locals.World[Property] ~= Value then
                Script.Locals.World[Property] = Value
            end

            return __newindex(Self, Property, Value)
        end))
    end

-- Ui    
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RewritingScripter1/UiLinoria/refs/heads/main/Gui%20Lib%20%5BLibrary%5D.txt"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/RewritingScripter1/UiLinoria/refs/heads/main/Gui%20Lib%20%5BThemeManager%5D.txt"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/RewritingScripter1/UiLinoria/refs/heads/main/Gui%20Lib%20%5BSaveManager%5D.txt"))()

local Window = Library:CreateWindow({
    
    Title = 'Private Mobile Tracer',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2

})

local Tabs = {
    Main = Window:AddTab('LEGIT'),
    Rage = Window:AddTab('Visuals'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local Main = Tabs.Main:AddLeftGroupbox('Main')
local Rah = Tabs.Main:AddRightGroupbox('Prediction Settings')
local Rah2 = Tabs.Main:AddRightGroupbox('Checks')
local Dick = Tabs.Rage:AddLeftGroupbox('Visual Things')
local Dick2 = Tabs.Rage:AddRightGroupbox('RageBot 🤑 Op Asf')

Main:AddButton({
    Text = 'Shiftlock [ Only For VFS ]',
    Func = function()
                if BuyItemsAlreadyLoaded then
           Library:Notify('Already Loaded')
           return
        end
        BuyItemsAlreadyLoaded = true
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RewritingScripter1/Files-Of-Script/refs/heads/main/intro.lua"))()
    Library:Notify('Shiftlock Loaded')
    end,
    Tooltip = 'Sigma Sigma Boy'
})

Main:AddButton({
    Text = 'Triggerbot',
    Func = function()
                if TriggerAlreadyLoaded then
           Library:Notify('Already Loaded')
           return
        end
        TriggerAlreadyLoaded = true
        local player = game.Players.LocalPlayer
local auto_shooting = false  -- Track whether auto shooting is on or off

local ShootGui = Instance.new("ScreenGui")
ShootGui.Parent = game.CoreGui

-- Stroke Frame
local ShootStrokeFrame = Instance.new("Frame")
ShootStrokeFrame.Size = UDim2.new(0, 130, 0, 70)
ShootStrokeFrame.Position = UDim2.new(0.5, -65, 0.5, -35)
ShootStrokeFrame.BackgroundTransparency = 1
ShootStrokeFrame.BorderSizePixel = 0
ShootStrokeFrame.Parent = ShootGui

-- Rounded corners for stroke frame
local ShootStrokeFrameCorner = Instance.new("UICorner")
ShootStrokeFrameCorner.CornerRadius = UDim.new(0, 12)
ShootStrokeFrameCorner.Parent = ShootStrokeFrame

-- Stroke
local ShootStroke = Instance.new("Frame")
ShootStroke.Size = UDim2.new(1, 0, 1, 0)
ShootStroke.Position = UDim2.new(0, 0, 0, 0)
ShootStroke.BackgroundTransparency = 1
ShootStroke.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ShootStroke.BorderSizePixel = 0
ShootStroke.BackgroundTransparency = 0.7
ShootStroke.Parent = ShootStrokeFrame

-- Rounded corners for stroke
local ShootStrokeCorner = Instance.new("UICorner")
ShootStrokeCorner.CornerRadius = UDim.new(0, 12)
ShootStrokeCorner.Parent = ShootStroke

-- Main Frame
local ShootFrame = Instance.new("Frame")
ShootFrame.Size = UDim2.new(0, 120, 0, 60)
ShootFrame.Position = UDim2.new(0.5, -60, 0.5, -30)
ShootFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ShootFrame.BorderSizePixel = 0
ShootFrame.BackgroundTransparency = 1
ShootFrame.Active = true
ShootFrame.Draggable = true
ShootFrame.ClipsDescendants = true
ShootFrame.Parent = ShootGui

local ShootFrameCorner = Instance.new("UICorner")
ShootFrameCorner.CornerRadius = UDim.new(0, 10)
ShootFrameCorner.Parent = ShootFrame

-- Toggle Button
local ShootButton = Instance.new("TextButton")
ShootButton.Size = UDim2.new(0, 100, 0, 50)
ShootButton.Position = UDim2.new(0.5, -50, 0.5, -25)
ShootButton.Text = "Auto Shoot"
ShootButton.TextScaled = true
ShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ShootButton.BackgroundTransparency = 0.6
ShootButton.BorderSizePixel = 0
ShootButton.ClipsDescendants = true
ShootButton.Parent = ShootFrame

-- Rounded corners for button
local ShootButtonCorner = Instance.new("UICorner")
ShootButtonCorner.CornerRadius = UDim.new(0, 10)
ShootButtonCorner.Parent = ShootButton

-- Function to toggle auto shooting
local function toggleAutoShoot()
    auto_shooting = not auto_shooting
    if auto_shooting then
        ShootButton.Text = "Auto Shoot: ON"
    else
        ShootButton.Text = "Auto Shoot: OFF"
    end
end

-- Connect button click to toggle function
ShootButton.MouseButton1Click:Connect(toggleAutoShoot)

-- Auto shoot function
local function AutoShoot()
    local targetPlayer = game.Players:GetPlayers()[2]  -- Change index as needed
    if targetPlayer and player.Character then
        local character = player.Character
        local tool = character:FindFirstChildOfClass("Tool")
        
        if tool and tool:IsA("Tool") then
            tool:Activate()
        end
    end
end

-- Connect to Heartbeat for auto shooting
game:GetService("RunService").Heartbeat:Connect(function()
    if auto_shooting then
        AutoShoot()
    end
end)

-- Function to update stroke frame
local function updateStrokeFrame()
    ShootStrokeFrame.Size = ShootFrame.Size + UDim2.new(0, 10, 0, 10)
    ShootStrokeFrame.Position = ShootFrame.Position - UDim2.new(0, 5, 0, 5)
end

-- Initial update call
updateStrokeFrame()

-- Connect update function to frame changes
ShootFrame:GetPropertyChangedSignal("Size"):Connect(updateStrokeFrame)
ShootFrame:GetPropertyChangedSignal("Position"):Connect(updateStrokeFrame)
    Library:Notify('Triggerbot Loaded')
    end,
    Tooltip = 'Sigma Sigma Boy'
})

Main:AddToggle('Toggle', {
    Text = 'Enable',
    Default = false, -- Default value (true / false)
    Tooltip = 'Tracer Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Enabled = Value
	    Settings.Combat.Silent = Value
    end
}):AddKeyPicker("TargetAimKeybind", {
          Default = "E",
          SyncToggleState = false,
          Mode = "Toggle",
          Text = "Keybind To Toggle",
          NoUI = false,
          Callback = function()
            if getgenv().UseKey == true and Settings.Combat.Enabled then
		  Script.Locals.IsTargetting = not Script.Locals.IsTargetting
		  
		  local NewTarget = Script.Functions.GetClosestPlayer()
		  Script.Locals.Target = Script.Locals.IsTargetting and NewTarget.Character and NewTarget or nil
		  
		  if Settings.Combat.Alerts then
		     Library:Notify('Tracer.lel | Notifys | Aiming To : ' .. Script.Locals.Target.Character.Humanoid.DisplayName)
		  end
		end
	end    
})

local BlaaadLock = Instance.new("ScreenGui")
BlaaadLock.Name = "BlaaadLock"
BlaaadLock.Parent = game.CoreGui
BlaaadLock.ZIndexBehavior = Enum.ZIndexBehavior.Global
BlaaadLock.ResetOnSpawn = false
local Frame = Instance.new("Frame")
Frame.Parent = BlaaadLock
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
Frame.Size = UDim2.new(0, 80, 0, 70)
Frame.Active = true
Frame.Draggable = true

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Parent = Frame
Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Logo.BackgroundTransparency = 5.000
Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0.326732665, 0, 0, 0)
Logo.Size = UDim2.new(0, 43, 0, 43)
Logo.Image = "rbxassetid://YOUR_IMAGE_ID" -- Replace YOUR_IMAGE_ID
Logo.ImageTransparency = 0.200

local TextButton = Instance.new("TextButton")
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 5.000
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0792079195, 0, 0.18571429, 0)
TextButton.Size = UDim2.new(0, 80, 0, 44)
TextButton.Font = Enum.Font.SourceSansSemibold
TextButton.Text = "Tracer.lel"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true

local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame

local state = true
TextButton.MouseButton1Click:Connect(function()
if Settings.Combat.Enabled then
    Script.Locals.IsTargetting = not Script.Locals.IsTargetting
    
    local NewTarget = Script.Functions.GetClosestPlayer()
    Script.Locals.Target = Script.Locals.IsTargetting and NewTarget.Character and NewTarget or nil
    
    if Settings.Combat.Alerts then
      Library:Notify('Tracer.lel | Notifys | Aiming To : ' .. Script.Locals.Target.Character.Humanoid.DisplayName)      
    end
  end
end)

Main:AddToggle('Toggle', {
    Text = 'Enable Keybind',
    Default = false, -- Default value (true / false)
    Tooltip = 'Keybind Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        getgenv().UseKey = Value
    end
})

Main:AddToggle('Alerts Notify', {
    Text = 'Enable Alerts',
    Default = false, -- Default value (true / false)
    Tooltip = 'Alerts Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Alerts = Value
    end
})

Main:AddToggle('Enable Spectation', {
    Text = 'Enable Spectate',
    Default = false, -- Default value (true / false)
    Tooltip = 'Spectate Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Spectate = Value
    end
})

Main:AddToggle('Enable LookAt', {
    Text = 'Enable LookAt',
    Default = false, -- Default value (true / false)
    Tooltip = 'LookAt Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.LookAt = Value
    end
})

Main:AddDropdown('Select HitPart', {
    Values = { "Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightLowerLeg", "RightFoot", "RightUpperLeg" },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
    Text = 'Hitpart',
    Tooltip = 'Select Hitpart Nigga', -- Information shown when you hover over the dropdown
    Callback = function(Value)
        Settings.Combat.AimPart = Value
    end
})

Main:AddToggle('Enable Resolver', {
    Text = 'Enable Resolver',
    Default = false, -- Default value (true / false)
    Tooltip = 'Resolver Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Resolver.Enabled = Value
    end
})

Main:AddSlider('Refresh Rate Resolver', {
    Text = 'Resolver RefreshRate',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        Settings.Combat.Resolver.RefreshRate = Value
    end
})

Rah:AddInput('Prediction', {
    Default = 'Prediction Amount',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter
    Text = 'Prediction',
    Tooltip = 'Place Your Prediction Here',
    Placeholder = '0.160126357',
    Callback = function(Value)
        Settings.Combat.Prediction.PredictionAmount = Value
    end
})

Rah:AddToggle('Enable JumpOffset', {
    Text = 'Enable JumpOffset',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Air.Enabled = Value
    end
})

Rah:AddInput('JumpOffset', {
    Default = '0.62',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter
    Text = 'JumpOffSet Amount',
    Tooltip = 'Place Your Offset Here',
    Placeholder = '',
    Callback = function(Value)
        Settings.Combat.Air.JumpOffset.Enabled = Value
    end
})

Rah2:AddToggle('Enable Enable Checks', {
    Text = 'Enable Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Checks.Enabled = Value
    end
})

Rah2:AddToggle('Enable JumpOffset', {
    Text = 'Enable Knocked Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Checks.Knocked = Value
    end
})

Rah2:AddToggle('Enable JumpOffset', {
    Text = 'Enable Crew Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Checks.Crew = Value
    end
})

Rah2:AddToggle('Enable JumpOffset', {
    Text = 'Enable Vehicle Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Checks.Vehicle = Value
    end
})

Rah2:AddToggle('Enable JumpOffset', {
    Text = 'Enable Wall Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Checks.Wall = Value
    end
})

Rah2:AddToggle('Enable JumpOffset', {
    Text = 'Enable Grabbed Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Checks.Grabbed = Value
    end
})

Dick:AddToggle('Enable JumpOffset', {
    Text = 'Enable Visuals',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Visuals.Enabled = Value
    end
})

Dick:AddToggle('Enable Resolver', {
    Text = 'Enable Tracer',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Visuals.Tracer.Enabled = Value
    end
}):AddColorPicker('Tracer Color', {
    Default = Color3.new(1, 1, 1), -- Bright green
    Title = 'Tracer color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)
    Callback = function(Value)
        Settings.Combat.Visuals.Tracer.Color = Value
    end
})

Dick:AddSlider('Refresh Rate Resolver', {
    Text = 'Tracer Thickness',
    Default = 1,
    Min = 0,
    Max = 3,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.Combat.Visuals.Tracer.Thickness = Value
    end
})

Dick:AddToggle('Enable JumpOffset', {
    Text = 'Enable Dot On Enemy',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Visuals.Dot.Enabled = Value
    end
}):AddColorPicker('Dot Color', {
    Default = Color3.new(1, 1, 1), -- Bright green
    Title = 'Dot color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)
    Callback = function(Value)
        Settings.Combat.Visuals.Dot.Color = Value
    end
})

Dick:AddToggle('Enable', {
    Text = 'Enable Dot Filled',
    Default = false, -- Default value (true / false)
    Tooltip = 'LookAt Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Visuals.Dot.Filled = Value
    end
})

Dick:AddSlider('Dot Size', {
    Text = 'Dot Size',
    Default = 5,
    Min = 0,
    Max = 7,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.Combat.Visuals.Dot.Size = Value
    end
})

Dick:AddToggle('Enable Cham', {
    Text = 'Enable Cham',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.Combat.Visuals.Chams.Enabled = Value
    end
}):AddColorPicker('cham Color', {
    Default = Color3.new(1, 1, 1), -- Bright green
    Title = 'Cham color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)
    Callback = function(Value)
        Settings.Combat.Visuals.Chams.Outline.Color = Value
        Settings.Combat.Visuals.Chams.Fill.Color = Value
    end
})

Dick2:AddToggle('Enable RageBot', {
    Text = 'Enable RageBot',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.AntiAim.CSync.Enabled = Value
    end
})

Dick2:AddToggle('Enable RageBot', {
    Text = 'Enable Visualize',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enabled', -- Information shown when you hover over the toggle
    Callback = function(Value)
        Settings.AntiAim.CSync.Visualize.Enabled = Value
    end
}):AddColorPicker('cham Color', {
    Default = Color3.new(1, 1, 1), -- Bright green
    Title = 'Cham color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)
    Callback = function(Value)
        Settings.AntiAim.CSync.Visualize.Color = Value
    end
})

Dick2:AddDropdown('Select Rage type', {
    Values = { "Custom", "Random Target", "Target Strafe", "BoxRandom", "KillCheaters" },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
    Text = 'RageBot Type',
    Tooltip = 'SSelec RageType Nigga', -- Information shown when you hover over the dropdown
    Callback = function(Value)
        Settings.AntiAim.CSync.Type = Value
    end
})

Dick2:AddSlider('idk', {
    Text = 'Random Distance',
    Default = 10,
    Min = 0,
    Max = 30,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.AntiAim.CSync.RandomDistance = Value
    end
})

Dick2:AddInput('idk', {
    Default = '0',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter
    Text = 'Custom X Amount',
    Tooltip = '',
    Placeholder = '',
    Callback = function(Value)
        Settings.AntiAim.CSync.Custom.X = Value
    end
})

Dick2:AddInput('idk', {
    Default = '0',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter
    Text = 'Custom Y Amount',
    Tooltip = '',
    Placeholder = '',
    Callback = function(Value)
        Settings.AntiAim.CSync.Custom.Y = Value
    end
})

Dick2:AddInput('idk', {
    Default = '0',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter
    Text = 'Custom Z Amount',
    Tooltip = '',
    Placeholder = '',
    Callback = function(Value)
        Settings.AntiAim.CSync.Custom.Z = Value
    end
})

Dick2:AddSlider('idk', {
    Text = 'Rage Speed',
    Default = 5,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.AntiAim.CSync.TargetStrafe.Speed = Value
    end
})

Dick2:AddSlider('idk', {
    Text = 'Rage Distance',
    Default = 10,
    Min = 0,
    Max = 30,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.AntiAim.CSync.TargetStrafe.Distance = Value
    end
})
Dick2:AddSlider('idk', {
    Text = 'Rage Height',
    Default = 3,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.AntiAim.CSync.TargetStrafe.Height = Value
    end
})







--[[
Tab:AddToggle({
	Name = "Enable",
	Default = false,
	Callback = function(Value,sigmalockenable)
		Settings.AntiAim.CSync.Enabled = Value
	end    
})



Tab:AddToggle({
	Name = "Visualize",
	Default = false,
	Callback = function(Value)
		Settings.AntiAim.CSync.Visualize.Enabled = Value
	end    
})

Tab:AddColorpicker({
	Name = "Visualize Color",
	Default = Color3.fromRGB(255, 255, 255),
	Callback = function(Value)
		Settings.AntiAim.CSync.Visualize.Color = Value
	end	  
})

Tab:AddDropdown({
	Name = "Type",
	Default = "Custom",
	Options = {"Custom", "Random", "Random Target", "Target Strafe", "Local Strafe", "BoxRandom", "Test", "KillCheaters"},
	Callback = function(Value)
Settings.AntiAim.CSync.Type = Value
	end    
})

Tab:AddSlider({
	Name = "Random Distance",
	Min = 0,
	Max = 30,
	Default = 10,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Sigma",
	Callback = function(Value)
		Settings.AntiAim.CSync.RandomDistance = Value
	end    
})

Tab:AddTextbox({
	Name = "Custom X",
	Default = "0",
	TextDisappear = false,
	Callback = function(Value)
		Settings.AntiAim.CSync.Custom.X = Value
	end	  
})

Tab:AddTextbox({
	Name = "Custom Y",
	Default = "0",
	TextDisappear = false,
	Callback = function(Value)
		Settings.AntiAim.CSync.Custom.Y = Value
	end	  
})

Tab:AddTextbox({
	Name = "Custom Z",
	Default = "0",
	TextDisappear = false,
	Callback = function(Value)
		Settings.AntiAim.CSync.Custom.Z = Value
	end	  
})

Tab:AddSlider({
	Name = "Speed",
	Min = 0,
	Max = 40,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "bananas",
	Callback = function(Value)
		Settings.AntiAim.CSync.TargetStrafe.Speed = Value
	end    
})

Tab:AddSlider({
	Name = "Heigh",
	Min = -10,
	Max = 40,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "ohio",
	Callback = function(Value)
		Settings.AntiAim.CSync.TargetStrafe.Height = Value
	end    
})

Tab:AddSlider({
	Name = "Distance",
	Min = 0,
	Max = 40,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "skibidi",
	Callback = function(Value)
		Settings.AntiAim.CSync.TargetStrafe.Distance = Value
	end    
}) ]]

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('Tracer [[ Mobile Only ]] | Prediction: ' .. Settings.Combat.Prediction.PredictionAmount .. ' | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = false; -- todo: add a function for this

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    print('Unloaded!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('Tracer')
SaveManager:SetFolder('Tracer/Config')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

Library:Notify('Loaded Tracer')