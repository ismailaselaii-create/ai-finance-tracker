# AI Finance Tracker

Telegram bot for tracking income and expenses in natural language. Built with n8n, PostgreSQL and Groq (Llama 3.3 70B).

## Features
- Add transactions in plain text: "spent 3500 on food", "got salary 100000"
- AI extracts amount, type, category and date as JSON
- /balance: monthly income, expenses and net
- /history: last transactions, filters by category or "this week"
- /stats: spending breakdown by category with AI insights
- /budget food 20000: monthly budget limit per category
- /mybudgets: list budgets
- /delete: remove last transaction

## Stack
Telegram Bot API, n8n (self-hosted), PostgreSQL 16, Groq API, ngrok (webhook tunnel for local run)

## Setup
1. Create the database: `createdb finance_tracker` then `psql finance_tracker -f schema.sql`
2. Start n8n: `WEBHOOK_URL=https://<your-ngrok-domain> n8n start`
3. In n8n create credentials: Postgres account, Telegram account (bot token from @BotFather)
4. Import `workflow.json` (Workflows, Import from file)
5. Replace `YOUR_GROQ_API_KEY` in both HTTP Request nodes with your Groq key
6. Publish the workflow and message the bot

## Security notes
- Data is isolated per user by Telegram chat_id
- Secrets are kept in n8n credentials, never commit real keys
