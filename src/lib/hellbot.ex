defmodule Hellbot do
  import Poison

  ## always remember to do this 
  def setup do
    :inets.start()
    :ssl.start()
  end

  def request(:get) do
    url ='https://api.helldiversgame.com/1.0/'
    :httpc.request(url)
  end

  def request(method, action) do
    #actual request parameters
    url ='https://api.helldiversgame.com/1.0/' ## important note: urls between single quotes
    headers = []
    body_type = 'application/x-www-form-urlencoded'
    body = 'action=#{action}'

    # http parameters
    httpopts=[]
    options=[]
    :httpc.request(method,{url,headers,body_type,body},httpopts,options)  
  end

  def get_latest_snapshot(season) do
    {:ok,{{_,200,_},_headers, data}} = request(:post, 'get_snapshots&season=#{season}')
    {:ok, snapshot_data} = decode(data|> List.to_string)
    
    latest= snapshot_data
    |> Map.get("snapshots")
    |> Enum.at(-1)

    {:ok, time} = latest 
    |> Map.get("time")
    |> DateTime.from_unix

    {:ok, info} = latest  
    |> Map.get("data")
    |> decode

    {time, info}
  end

  def get_current_status do
    {:ok,{{_,200,_},_headers, data}} = request(:post, 'get_campaign_status')
    {:ok, campaign_status} = decode(data|> List.to_string)
    
    {:ok, time} = campaign_status 
    |> Map.get("time") 
    |> DateTime.from_unix

    status = campaign_status
    |> Map.get("campaign_status")

    {time, status}
  end

end
