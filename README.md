# Environmental Impact Analysis Agent System

## Project Overview

This project is a multi-agent system built with Solace Agent Mesh (SAM) that analyzes the environmental impact of user activities and compares them to regional averages. The system is designed to assess impact across multiple categories including Transportation, Agriculture, Building, Manufacturing, and Electricity usage, though currently only the Transportation category is fully implemented.

## Project Origins

This system originated from a one-day hackathon team project focused on environmental impact assessment. After the hackathon, I cleaned up the codebase, restructured the agent architecture, and refined it as a demonstration of multi-agent system development using the Solace Agent Mesh framework.

## System Architecture

The system consists of three main agents working in coordination:

### 1. Orchestrator Agent
- **Role**: Central coordinator and task delegator
- **Responsibilities**: 
  - Receives user input and determines appropriate agent delegation
  - Formats final responses in Environmental Impact Analysis format
  - Manages workflow between agents

### 2. Transportation Agent
- **Role**: Transportation impact analysis specialist
- **Responsibilities**:
  - Analyzes environmental impact of transportation methods
  - Compares user transportation behavior against regional averages
  - Researches climate impact data and transportation best practices
  - Communicates with Score Agent for normalized scoring

### 3. Score Agent
- **Role**: Environmental impact scoring specialist
- **Responsibilities**:
  - Provides numerical scores from -2 to +2 comparing user impact to regional averages
  - Compares user behavior against population averages in their geographic area
  - Applies standardized environmental impact scoring logic
  - The numerical score is meant to be utilized to update an external graphic using the climate stripes as a visualization to the user about the impact of their actions

## Response Format

The system returns structured environmental impact assessments:

```
# Environmental Impact Analysis
**Impact Assessment:** [Positive/Negative]
**Environmental Score:** [+2/-2]
## Key Findings
- [Main impact analysis point]
- [Comparison to local averages]
```

### Environmental Impact Scoring System
- **-2**: Significantly better than regional average (best practice)
- **-1**: Better than regional average
- **0**: At regional average
- **+1**: Worse than regional average
- **+2**: Significantly worse than regional average (poor practice)

## Planned Categories (Transportation Only Implemented)

The system is architected to handle multiple environmental impact categories:

- **🚗 Transportation** ✅ *Implemented*: Vehicle usage, public transit, cycling, walking
- **🌾 Agriculture** 🚧 *Planned*: Food consumption, local vs imported goods, dietary choices
- **🏢 Building** 🚧 *Planned*: Energy usage, heating/cooling, building efficiency
- **🏭 Manufacturing** 🚧 *Planned*: Consumer goods, electronics, clothing consumption
- **⚡ Electricity** 🚧 *Planned*: Home energy usage, renewable vs traditional sources

## Technical Features

- **Multi-Agent Coordination**: Agents communicate through Solace messaging
- **REST Gateway**: HTTP API available on port 8000
- **Real-time Streaming**: Server-Sent Events (SSE) for live updates
- **Graceful Shutdown**: Custom PowerShell script for clean process termination
- **Environment Management**: Secure API key handling via .env files

## Project Structure

```
├── configs/
│   ├── agents/              # Agent configurations
│   │   ├── main_orchestrator.yaml
│   │   ├── score_agent_agent.yaml
│   │   └── transportation_agent_agent.yaml
│   ├── gateways/           # Gateway configurations
│   │   └── main-gate.yaml
│   └── shared_config.yaml  # Common configuration
├── rebalance-app/          # Original hackathon codebase
├── shutdown_sam.ps1        # Graceful shutdown script
├── .env                    # Environment variables (not in repo)
├── .env.example           # Environment template
└── requirements.txt       # Python dependencies
```

## Setup Instructions

### Prerequisites
- Python 3.8+
- Solace Agent Mesh framework
- OpenAI API key (or compatible LLM service)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd environmental-impact-agent-system
   ```

2. **Set up environment**
   ```bash
   # Copy environment template
   cp .env.example .env
   
   # Edit .env with your API keys
   notepad .env
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the system**
   ```bash
   # Start the gateway and agents
   sam run configs/gateways/main-gate.yaml
   ```

5. **Access the system**
   - REST API: http://localhost:8000
   - WebUI: http://localhost:8000 (if enabled)

### Usage Example

Send a POST request to analyze transportation impact:

```bash
curl -X POST "http://localhost:8000/api/v1/chat/send" \
  -H "Content-Type: application/json" \
  -d '{
    "user_input": "I drove 15 miles to work today in my gas car in San Francisco"
  }'
```

**Example Response:**
```json
{
  "response": "# Environmental Impact Analysis\n**Impact Assessment:** Negative\n**Environmental Score:** +1\n## Key Findings\n- Your transportation generates higher emissions than SF Bay Area average\n- Consider public transit or carpooling for daily commute"
}
```

## Development Notes

### Key Improvements Made Post-Hackathon
- Restructured agent communication patterns for better efficiency
- Implemented proper error handling and graceful shutdowns
- Added comprehensive environment variable management
- Simplified the architecture by removing unnecessary complexity
- Created reusable shutdown procedures
- Enhanced security by removing hardcoded credentials

### Agent Communication Flow
```
User Input → REST Gateway → OrchestratorAgent → TransportationAgent → ScoreAgent
                                             ↓
User Response ← REST Gateway ← OrchestratorAgent ← TransportationAgent ← ScoreAgent
```

### Shutdown Management
Use the provided PowerShell script for clean shutdowns:
```powershell
.\shutdown_sam.ps1
```

## Configuration

### Environment Variables
Key environment variables (see .env.example):
- `LLM_SERVICE_API_KEY`: Your OpenAI or compatible API key
- `LLM_SERVICE_ENDPOINT`: LLM service endpoint
- `FASTAPI_PORT`: Gateway port (default: 8000)
- `NAMESPACE`: SAM namespace identifier

### Agent Configuration
Agents are configured via YAML files in the `configs/agents/` directory. Each agent can be customized for:
- Model selection (planning vs general models)
- Communication patterns (allow/deny lists)
- Timeout settings
- Instruction prompts

## Hackathon Legacy

This project demonstrates the evolution from a rapid prototype developed during a time-constrained hackathon environment to a cleaned, production-ready multi-agent system. The original team collaboration focused on environmental awareness through technology, and this refined version showcases:

- **Clean Architecture**: Well-organized agent separation of concerns
- **Scalable Design**: Modular components that can be extended
- **Production Practices**: Proper configuration management and security
- **Documentation**: Comprehensive setup and usage instructions

## Future Enhancements

The current implementation provides a foundation for expansion across multiple environmental categories:

### Immediate Improvements
- **Enhanced Geographic Data**: More precise regional comparison data
- **Real-time APIs**: Integration with transportation and energy data sources
- **User Profiles**: Personalized baselines and recommendations

### Category Expansion
- **Agriculture**: Food carbon footprint analysis, local sourcing assessment
- **Building**: Home energy efficiency, heating/cooling optimization
- **Manufacturing**: Consumer goods impact, lifecycle assessments
- **Electricity**: Grid composition analysis, renewable energy usage

### Technical Enhancements
- Machine learning models for personalized recommendations
- Mobile app integration for real-time data collection
- Dashboard for tracking environmental impact over time
- Integration with IoT devices for automatic data collection

## License

[Add your preferred license here]

## Contributors

Originally developed as a team hackathon project, subsequently refined and documented as a portfolio demonstration piece.
