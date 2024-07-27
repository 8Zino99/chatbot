local HttpService = game:GetService("HttpService")

-- GUI Elemente
local mainFrame = script.Parent:WaitForChild("MainFrame")
local codeInputBox = mainFrame:WaitForChild("CodeInputBox")
local executeButton = mainFrame:WaitForChild("ExecuteButton")
local outputLabel = mainFrame:WaitForChild("OutputLabel")
local aiButton = mainFrame:WaitForChild("AIButton")
local chatFrame = mainFrame:WaitForChild("ChatFrame")
local chatInputBox = chatFrame:WaitForChild("ChatInputBox")
local chatOutputLabel = chatFrame:WaitForChild("ChatOutputLabel")
local sendButton = chatFrame:WaitForChild("SendButton")

-- API Schlüssel und URL
local apiKey = "rp-aWSpZNE2OWwNAig0mrm4WDTNY4mC59wEqlc9kKVXZhdXk3Br"
local apiUrl = "https://api.openai.com/v1/engines/davinci-codex/completions"

-- Code ausführen
executeButton.MouseButton1Click:Connect(function()
    local code = codeInputBox.Text
    local success, errorMessage = pcall(function()
        loadstring(code)()
    end)
    if success then
        outputLabel.Text = "Code erfolgreich ausgeführt."
    else
        outputLabel.Text = "Fehler: " .. errorMessage
    end
end)

-- AI Button klick
aiButton.MouseButton1Click:Connect(function()
    chatFrame.Visible = not chatFrame.Visible
end)

-- Anfrage an die OpenAI API senden
sendButton.MouseButton1Click:Connect(function()
    local prompt = chatInputBox.Text
    local response = nil

    local success, errorMessage = pcall(function()
        response = HttpService:PostAsync(
            apiUrl,
            HttpService:JSONEncode({
                prompt = prompt,
                max_tokens = 300,
                temperature = 0.7
            }),
            Enum.HttpContentType.ApplicationJson,
            false,
            { ["Authorization"] = "Bearer " .. apiKey }
        )
    end)

    if success then
        local responseData = HttpService:JSONDecode(response)
        if responseData and responseData.choices and responseData.choices[1] then
            local generatedResponse = responseData.choices[1].text
            chatOutputLabel.Text = generatedResponse
        else
            chatOutputLabel.Text = "Fehler beim Abrufen der Antwort."
        end
    else
        chatOutputLabel.Text = "Fehler bei der Anfrage: " .. errorMessage
    end
end)
