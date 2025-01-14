local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Helper function to make UI elements draggable
local function makeDraggable(guiObject)
    local dragging = false
    local dragInput, dragStart, startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Create TextBox for input
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0, 300, 0, 50) -- Width: 300px, Height: 50px
inputBox.Position = UDim2.new(0.5, -150, 0.4, 0) -- Centered horizontally
inputBox.AnchorPoint = Vector2.new(0.5, 0.5)
inputBox.PlaceholderText = "Type here..."
inputBox.Text = ""
inputBox.Parent = screenGui

-- Create TextButton for processing
local processButton = Instance.new("TextButton")
processButton.Size = UDim2.new(0, 150, 0, 50)
processButton.Position = UDim2.new(0.5, -75, 0.5, 0) -- Below the TextBox
processButton.AnchorPoint = Vector2.new(0.5, 0.5)
processButton.Text = "Transform & Copy"
processButton.Parent = screenGui

-- Create TextLabel for displaying the result
local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(0, 300, 0, 50)
resultLabel.Position = UDim2.new(0.5, -150, 0.6, 0) -- Below the button
resultLabel.AnchorPoint = Vector2.new(0.5, 0.5)
resultLabel.Text = ""
resultLabel.TextWrapped = true
resultLabel.Parent = screenGui

-- Make elements draggable
makeDraggable(inputBox)
makeDraggable(processButton)
makeDraggable(resultLabel)

-- Add functionality to the button
processButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local transformedText = ""

    -- Transform the text by appending ">" to the last character of each word
    for word in inputText:gmatch("%S+") do
        local modifiedWord = word:sub(1, #word - 1) .. "<" .. word:sub(#word)
        transformedText = transformedText .. modifiedWord .. " "
    end

    -- Trim trailing space
    transformedText = transformedText:sub(1, -2)

    -- Update the result label
    resultLabel.Text = transformedText

    -- Copy the transformed text to the clipboard (only works in Studio, not live game)
    if setclipboard then
        setclipboard(transformedText)
        print("Text copied to clipboard!")
    else
        print("Copying to clipboard is only available in Roblox Studio.")
    end
end)
