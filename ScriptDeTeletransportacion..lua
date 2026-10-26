
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ELIMINAR LA INTERFAZ ANTERIOR
local oldGui = playerGui:FindFirstChild("TeleportGui")
if oldGui then
    oldGui:Destroy()
end

-- CONFIGURACION
local FADE_TIME = 4

-- CREAR INTERFAZ
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.Parent = playerGui

-- CUADRO PRINCIPAL
local panel = Instance.new("Frame")
panel.Name = "TeleportPanel"
panel.Size = UDim2.fromOffset(350, 185)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.BackgroundColor3 = Color3.new(1, 1, 1)
panel.BorderSizePixel = 0
panel.Parent = gui

local function addBorder(object, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Border"
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = thickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = object
    return stroke
end

addBorder(panel, 4)

-- BARRA SUPERIOR PARA ARRASTRAR
local dragBar = Instance.new("TextButton")
dragBar.Name = "DragBar"
dragBar.Size = UDim2.fromOffset(135, 13)
dragBar.Position = UDim2.new(0.5, 0, 0, -13)
dragBar.AnchorPoint = Vector2.new(0.5, 0)
dragBar.BackgroundColor3 = Color3.new(1, 1, 1)
dragBar.BorderSizePixel = 0
dragBar.Text = ""
dragBar.AutoButtonColor = false
dragBar.Active = true
dragBar.Parent = panel

addBorder(dragBar, 3)

-- SISTEMA PARA MOVER EL CUADRO
local dragging = false
local dragInput
local dragStart
local startPosition

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

-- CAMPOS DE COORDENADAS Z, Y, X
local coordinateFrame = Instance.new("Frame")
coordinateFrame.Name = "Coordinates"
coordinateFrame.Size = UDim2.new(1, -30, 0, 84)
coordinateFrame.Position = UDim2.fromOffset(15, 17)
coordinateFrame.BackgroundColor3 = Color3.new(1, 1, 1)
coordinateFrame.BorderSizePixel = 0
coordinateFrame.Parent = panel

addBorder(coordinateFrame, 4)

local fields = {}

local function createField(axis, index)
    local box = Instance.new("TextBox")
    box.Name = axis
    box.Size = UDim2.new(1/3, -8, 1, -10)
    box.Position = UDim2.new((index - 1)/3, 4, 0, 2)
    box.BackgroundTransparency = 1
    box.Text = ""
    box.PlaceholderText = axis
    box.PlaceholderColor3 = Color3.new(0, 0, 0)
    box.TextColor3 = Color3.new(0, 0, 0)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 25
    box.TextScaled = false
    box.TextWrapped = false
    box.TextStrokeTransparency = 1
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Center
    box.TextYAlignment = Enum.TextYAlignment.Center
    box.Parent = coordinateFrame

    local line = Instance.new("Frame")
    line.Name = "Underline"
    line.Size = UDim2.new(1, -8, 0, 1)
    line.Position = UDim2.new(0, 4, 1, -15)
    line.BackgroundColor3 = Color3.new(0, 0, 0)
    line.BorderSizePixel = 0
    line.Parent = box

    fields[axis] = box
end

createField("Z", 1)
createField("Y", 2)
createField("X", 3)

-- CREAR BOTONES CON TEXTO CORREGIDO
local function createButton(name, text, size, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 0

    button.Text = text
    button.TextColor3 = Color3.new(0, 0, 0)
    button.Font = Enum.Font.GothamBold

    -- Evitar texto amontonado o deformado
    button.TextSize = 18
    button.TextScaled = false
    button.TextWrapped = false
    button.TextStrokeTransparency = 1
    button.RichText = false
    button.TextXAlignment = Enum.TextXAlignment.Center
    button.TextYAlignment = Enum.TextYAlignment.Center
    button.AutoButtonColor = true

    button.Parent = panel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = button

    addBorder(button, 4)

    return button
end

local returnButton = createButton(
    "Devolver",
    "DEVOLVER",
    UDim2.fromOffset(210, 47),
    UDim2.fromOffset(17, 116)
)

local goButton = createButton(
    "Ir",
    "IR",
    UDim2.fromOffset(97, 47),
    UDim2.fromOffset(236, 116)
)

-- MENSAJE DE ESTADO
local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, -10, 0, 20)
status.Position = UDim2.new(0, 5, 1, -1)
status.AnchorPoint = Vector2.new(0, 1)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.new(0.7, 0, 0)
status.TextSize = 14
status.TextScaled = false
status.TextStrokeTransparency = 1
status.Font = Enum.Font.SourceSans
status.Parent = panel

-- ESTRELLA QUE SIEMPRE PERMANECE VISIBLE
local star = Instance.new("TextButton")
star.Name = "ToggleStar"
star.Size = UDim2.fromOffset(38, 42)
star.BackgroundTransparency = 1
star.BorderSizePixel = 0
star.Text = "★"
star.TextColor3 = Color3.new(0, 0, 0)
star.TextSize = 38
star.TextScaled = false
star.Font = Enum.Font.SourceSansBold
star.AutoButtonColor = false
star.ZIndex = 10
star.Parent = gui

local function updateStarPosition()
    star.Position = UDim2.fromOffset(
        panel.AbsolutePosition.X + panel.AbsoluteSize.X + 3,
        panel.AbsolutePosition.Y - 13
    )
end

panel:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateStarPosition)
panel:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateStarPosition)
task.defer(updateStarPosition)

-- DESVANECIMIENTO COMPLETO, INCLUIDOS TODOS LOS BORDES
local savedProperties = {}
local fading = false
local panelVisible = true

local function remember(object, property)
    savedProperties[object] = savedProperties[object] or {}

    if savedProperties[object][property] then
        return
    end

    local ok, value = pcall(function()
        return object[property]
    end)

    if ok then
        savedProperties[object][property] = {
            property = property,
            value = value
        }
    end
end

local function prepareFade()
    remember(panel, "BackgroundTransparency")

    for _, object in ipairs(panel:GetDescendants()) do
        if object:IsA("GuiObject") then
            remember(object, "BackgroundTransparency")

            if object:IsA("TextLabel")
                or object:IsA("TextButton")
                or object:IsA("TextBox") then

                remember(object, "TextTransparency")
                remember(object, "TextStrokeTransparency")
            end

            if object:IsA("TextBox") then
                remember(object, "PlaceholderColor3")
            end

            if object:IsA("ImageLabel")
                or object:IsA("ImageButton") then
                remember(object, "ImageTransparency")
            end

        elseif object:IsA("UIStroke") then
            -- Guardar la transparencia de cada borde negro
            remember(object, "Transparency")
        end
    end
end

prepareFade()

local function fadePanel(show)
    if fading or show == panelVisible then
        return
    end

    fading = true

    local tweens = {}
    local info = TweenInfo.new(
        FADE_TIME,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )

    -- Desactivar controles mientras ocurre la transición
    for _, object in ipairs(panel:GetDescendants()) do
        if object:IsA("GuiButton") or object:IsA("TextBox") then
            object.Active = false

            if object:IsA("GuiButton") then
                object.Interactable = false
            end
        end
    end

    -- Animar fondos, textos, líneas y bordes
    for object, properties in pairs(savedProperties) do
        if object and object.Parent then
            local target = {}

            for _, data in pairs(properties) do
                local property = data.property
                local original = data.value

                if property == "PlaceholderColor3" then
                    target[property] = show
                        and original
                        or Color3.new(1, 1, 1)

                elseif typeof(original) == "number" then
                    target[property] = show and original or 1
                end
            end

            if next(target) then
                local ok, tween = pcall(function()
                    return TweenService:Create(object, info, target)
                end)

                if ok then
                    table.insert(tweens, tween)
                end
            end
        end
    end

    for _, tween in ipairs(tweens) do
        tween:Play()
    end

    task.wait(FADE_TIME)

    -- Restaurar el aspecto original al reaparecer
    if show then
        for object, properties in pairs(savedProperties) do
            if object and object.Parent then
                for _, data in pairs(properties) do
                    pcall(function()
                        object[data.property] = data.value
                    end)
                end
            end
        end
    end

    panelVisible = show

    for _, object in ipairs(panel:GetDescendants()) do
        if object:IsA("GuiButton") or object:IsA("TextBox") then
            object.Active = true

            if object:IsA("GuiButton") then
                object.Interactable = true
            end
        end
    end

    fading = false
end

star.Activated:Connect(function()
    if fading then
        return
    end

    fadePanel(not panelVisible)
end)

-- TELETRANSPORTE
local previousPosition = nil
local busy = false

local function getCharacter()
    local character = player.Character

    if not character then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.Health <= 0 then
        return nil
    end

    return character
end

goButton.Activated:Connect(function()
    if busy or fading then
        return
    end

    local z = tonumber(fields.Z.Text)
    local y = tonumber(fields.Y.Text)
    local x = tonumber(fields.X.Text)

    if not z or not y or not x then
        status.Text = "Escribe Z, Y y X correctamente."
        return
    end

    if math.abs(x) > 1000000
        or math.abs(y) > 1000000
        or math.abs(z) > 1000000 then

        status.Text = "Las coordenadas son demasiado grandes."
        return
    end

    local character = getCharacter()

    if not character then
        status.Text = "No se encontró tu personaje."
        return
    end

    busy = true
    previousPosition = character:GetPivot()

    local success, err = pcall(function()
        character:PivotTo(CFrame.new(x, y, z))
    end)

    if success then
        status.Text = "¡Teletransporte realizado!"
    else
        status.Text = "No se pudo teletransportar."
        warn(err)
        previousPosition = nil
    end

    busy = false
end)

returnButton.Activated:Connect(function()
    if busy or fading then
        return
    end

    if not previousPosition then
        status.Text = "Primero debes pulsar IR."
        return
    end

    local character = getCharacter()

    if not character then
        status.Text = "No se encontró tu personaje."
        return
    end

    busy = true

    local success, err = pcall(function()
        character:PivotTo(previousPosition)
    end)

    if success then
        previousPosition = nil
        status.Text = "¡Has vuelto a tu posición anterior!"
    else
        status.Text = "No se pudo regresar."
        warn(err)
    end

    busy = false
end)
