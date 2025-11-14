local prompts = {
  -- Code related prompts
  Explain = "Please explain how the following code works.",
  Review = "Please review the following code and provide suggestions for improvement.",
  Tests = "Please explain how the selected code works, then generate unit tests for it.",
  Refactor = "Please refactor the following code to improve its clarity and readability.",
  FixCode = "Please fix the following code to make it work as intended.",
  FixError = "Please explain the error in the following text and provide a solution.",
  BetterNamings = "Please provide better names for the following variables and functions.",
  Documentation = "Please provide documentation for the following code.",
  SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
  SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
  -- Text related prompts
  Summarize = "Please summarize the following text.",
  Spelling = "Please correct any grammar and spelling errors in the following text.",
  Wording = "Please improve the grammar and wording of the following text.",
  Concise = "Please rewrite the following text to make it more concise.",
  Commit = {
    prompt = "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.",
    context = { "git:staged", "buffer" },
    model = "gpt-4o",
  },
  ReactDesignPattern = {
    prompt = "Analyze the following code and suggest the most suitable React Design Pattern, Best practice to improve its structure and maintainability. Provide a brief explanation of why this pattern is appropriate or why the current approach is effective. Focus on best practices, scalability and performance. If the code is already well-structured, simply state that no changes are necessary and explain why.",
    system_prompt = "You are a Senior React, React Native developer with over 10 years of experience. You know everything about Design Patterns, Clean Code, Refactoring, and best practices all by using TYPESCRIPT",
    context = { "buffer", "git:diff" },
  },
  ReactPerformance = {
    prompt = "Analyze the following React/React Native code for performance optimization opportunities. Focus on: re-renders, memory leaks, bundle size, lazy loading, memoization, and virtualization. Provide specific recommendations with code examples using TypeScript.",
    system_prompt = "You are a React/React Native performance expert with deep knowledge of React internals, profiling tools, and optimization techniques. You specialize in identifying performance bottlenecks and providing actionable solutions.",
    context = { "buffer", "git:diff" },
  },
  ReactTesting = {
    prompt = "Generate comprehensive test coverage for the following React/React Native component or hook. Include unit tests, integration tests, and accessibility tests using React Testing Library, Jest, and appropriate testing patterns. Focus on edge cases and user interactions.",
    system_prompt = "You are a Senior QA Engineer and React developer specializing in test-driven development, accessibility testing, and comprehensive test coverage strategies for React/React Native applications.",
    context = { "buffer" },
  },
  ReactNativeOptimization = {
    prompt = "Analyze this React Native code for mobile-specific optimizations including: performance, battery usage, memory management, navigation patterns, platform-specific considerations (iOS/Android), and user experience improvements.",
    system_prompt = "You are a React Native expert with extensive experience in mobile app development, platform-specific optimizations, and mobile UX patterns. You understand the nuances of both iOS and Android platforms.",
    context = { "buffer", "git:diff" },
  },
  ReactHooks = {
    prompt = "Review the following React hooks usage and suggest improvements. Focus on: custom hooks extraction, dependency arrays, hook rules compliance, performance implications, and reusability. Provide refactored examples using TypeScript.",
    system_prompt = "You are a React hooks specialist with deep understanding of React lifecycle, hook internals, and functional programming patterns. You excel at creating reusable and performant custom hooks.",
    context = { "buffer" },
  },
  ReactStateManagement = {
    prompt = "Analyze the state management approach in the following code. Suggest the most appropriate state management solution (useState, useReducer, Context API, Zustand, Redux Toolkit, etc.) based on complexity and requirements. Provide implementation examples.",
    system_prompt = "You are a state management expert for React applications with experience in various solutions from simple local state to complex global state management patterns.",
    context = { "buffer", "git:diff" },
  },
  ReactAccessibility = {
    prompt = "Audit the following React/React Native component for accessibility (a11y) compliance. Check for: ARIA attributes, keyboard navigation, screen reader support, color contrast, focus management, and semantic HTML. Provide specific improvements.",
    system_prompt = "You are an accessibility expert specializing in React/React Native applications. You have deep knowledge of WCAG guidelines, assistive technologies, and inclusive design principles.",
    context = { "buffer" },
  },
  ReactTypeScript = {
    prompt = "Improve the TypeScript implementation in the following React code. Focus on: proper typing, generic usage, utility types, strict type checking, and type safety best practices. Provide enhanced type definitions and interfaces.",
    system_prompt = "You are a TypeScript expert with specialized knowledge in React TypeScript patterns, advanced type definitions, and type-safe development practices.",
    context = { "buffer" },
  },
  -- React 19 Specific Prompts
  React19Implementation = {
    prompt = [[
Analyze the selected code and implement React 19 best practices and patterns.

Context:
- React 19 features: Actions, useOptimistic, use() hook, ref as prop, async transitions
- Follow modern React patterns: Server Components, Suspense boundaries, Error boundaries
- Prioritize: Type safety, performance, accessibility, and maintainability

Requirements:
1. Identify opportunities to use React 19 features (Actions, useOptimistic, use(), ref forwarding)
2. Implement proper error handling with Error Boundaries
3. Add loading states with Suspense where appropriate
4. Use Server Components by default, Client Components only when needed ('use client')
5. Implement proper TypeScript typing with latest React 19 types
6. Add JSDoc comments for complex logic
7. Ensure accessibility (ARIA labels, semantic HTML, keyboard navigation)
8. Optimize performance (memo, lazy loading, code splitting)

Output:
- Refactored code with React 19 best practices
- Explanation of changes and why they improve the code
- Performance and accessibility improvements
- Type-safe implementations

Selected code:
]],
    description = "Implement React 19 best practices and modern patterns",
    system_prompt = [[You are a React 19 expert specializing in modern web development.
You have deep knowledge of:
- React 19 features (Actions, useOptimistic, use hook, async transitions)
- Server Components and Client Components architecture
- Performance optimization techniques
- TypeScript with React
- Accessibility standards (WCAG 2.1 AA)
- Modern state management patterns

Always provide production-ready, type-safe, and well-documented code.]],
  },

  React19Audit = {
    prompt = [[
Perform a comprehensive React 19 compatibility and best practices audit on the selected code.

Audit Checklist:
1. **React 19 Features Usage**
   - Are you using Actions instead of manual form handling?
   - Could useOptimistic improve user experience?
   - Are async transitions properly handled?
   - Is the use() hook leveraged for async data?

2. **Component Architecture**
   - Are Server Components used by default?
   - Are Client Components marked with 'use client' only when necessary?
   - Is component composition optimal?

3. **Performance**
   - Are there unnecessary re-renders?
   - Is code splitting implemented where beneficial?
   - Are expensive computations memoized?
   - Are images and assets optimized?

4. **Type Safety**
   - Are all props properly typed?
   - Are React 19 types (ReactNode, JSX.Element, etc.) used correctly?
   - Are there any 'any' types that should be specific?

5. **Error Handling**
   - Are Error Boundaries implemented?
   - Are async errors caught properly?
   - Are fallback UIs provided?

6. **Accessibility**
   - Are semantic HTML elements used?
   - Are ARIA labels present where needed?
   - Is keyboard navigation supported?

7. **State Management**
   - Is state lifted appropriately?
   - Are context providers optimized?
   - Is local state preferred over global when possible?

Output:
- Detailed findings with severity (Critical, High, Medium, Low)
- Specific code locations of issues
- Actionable recommendations with code examples
- Migration path from React 18 patterns if applicable

Selected code:
]],
    description = "Audit code for React 19 best practices and compatibility",
    system_prompt = [[You are a senior React architect and code auditor with expertise in:
- React 19 migration and best practices
- Performance profiling and optimization
- Security vulnerabilities in React applications
- Accessibility compliance (WCAG)
- Code quality standards

Provide detailed, actionable feedback with specific examples and priorities.]],
  },

  NextJSImplementation = {
    prompt = [[
Implement Next.js App Router best practices and optimize the selected code.

Context:
- Next.js 15+ with App Router
- Server Components first approach
- Modern data fetching patterns
- TypeScript strict mode

Requirements:
1. **Routing & Layout**
   - Use App Router conventions (app directory)
   - Implement proper layout hierarchy
   - Use route groups for organization
   - Implement parallel routes where beneficial

2. **Data Fetching**
   - Use native fetch with Next.js extensions (cache, revalidate)
   - Implement proper caching strategies (force-cache, no-store, revalidate)
   - Use Server Actions for mutations
   - Stream data with Suspense boundaries

3. **Performance**
   - Implement proper image optimization with next/image
   - Use font optimization with next/font
   - Implement dynamic imports for client components
   - Add proper metadata for SEO

4. **Server/Client Components**
   - Keep components as Server Components by default
   - Only use 'use client' when necessary (interactivity, browser APIs, hooks)
   - Pass Server Component data to Client Components properly

5. **Error Handling**
   - Implement error.tsx for error boundaries
   - Add loading.tsx for loading states
   - Use not-found.tsx for 404 handling

6. **TypeScript**
   - Use proper Next.js types (Metadata, Route Params, Search Params)
   - Type page props correctly
   - Type Server Actions with proper return types

Output:
- Optimized Next.js code following latest conventions
- Explanation of architectural decisions
- Performance improvements
- SEO and metadata enhancements

Selected code:
]],
    description = "Implement Next.js best practices with App Router",
    system_prompt = [[You are a Next.js expert specializing in modern full-stack development.
Your expertise includes:
- Next.js 15+ App Router architecture
- Server Components and Client Components patterns
- Advanced caching strategies
- Performance optimization (Core Web Vitals)
- SEO and metadata management
- TypeScript with Next.js
- Server Actions and data mutations
- Deployment optimization (Vercel, self-hosted)

Always provide production-ready, performant, and SEO-optimized solutions.]],
  },

  NextJSAudit = {
    prompt = [[
Conduct a comprehensive Next.js audit focusing on App Router best practices and performance.

Audit Areas:

1. **Architecture**
   - Is App Router used correctly?
   - Are route segments organized logically?
   - Are layouts used for shared UI?
   - Are route groups used for organization?

2. **Server/Client Components**
   - Are Server Components used by default?
   - Are Client Components only used when necessary?
   - Is data passed correctly between server and client?
   - Are there client components that could be server components?

3. **Data Fetching**
   - Are fetch requests using Next.js caching extensions?
   - Is data fetching done in Server Components?
   - Are Server Actions used for mutations?
   - Is revalidation configured properly?

4. **Performance**
   - Are images optimized with next/image?
   - Are fonts optimized with next/font?
   - Is code splitting implemented?
   - Are bundle sizes reasonable?
   - Are Core Web Vitals optimized?

5. **Caching Strategy**
   - Is the right cache strategy used for each request?
   - Are dynamic routes handling caching correctly?
   - Is on-demand revalidation implemented where needed?

6. **SEO & Metadata**
   - Is metadata exported from pages?
   - Are Open Graph tags present?
   - Is dynamic metadata used for dynamic routes?
   - Are canonical URLs set?

7. **Error Handling**
   - Are error.tsx boundaries implemented?
   - Are loading.tsx files present?
   - Is not-found.tsx used?
   - Are errors properly logged?

8. **TypeScript**
   - Are page props typed correctly?
   - Are params and searchParams typed?
   - Are Server Actions properly typed?

9. **Security**
   - Are environment variables properly configured?
   - Are API routes secured?
   - Is CSRF protection in place for Server Actions?

Output:
- Prioritized list of issues
- Specific recommendations with code examples
- Performance improvement opportunities
- Migration steps if needed

Selected code:
]],
    description = "Audit Next.js code for best practices and performance",
    system_prompt = [[You are a Next.js architect specializing in audits and optimization.
Your skills include:
- Next.js App Router deep dive knowledge
- Performance profiling (Lighthouse, Web Vitals)
- Security best practices
- SEO optimization
- Caching strategies
- Scalability patterns

Provide thorough, prioritized findings with actionable solutions.]],
  },

  GenerateTests = {
    prompt = [[
Generate comprehensive tests for the selected code following modern testing best practices.

Test Requirements:

1. **Testing Framework Setup**
   - Use Vitest or Jest with React Testing Library
   - Include proper TypeScript types
   - Set up necessary mocks and providers

2. **Test Coverage**
   - Unit tests for utility functions
   - Component tests for UI components
   - Integration tests for user workflows
   - Edge cases and error scenarios

3. **React Component Testing**
   - Test user interactions (click, input, submit)
   - Test conditional rendering
   - Test async behavior (loading, success, error states)
   - Test accessibility (screen reader, keyboard navigation)
   - Use user-centric queries (getByRole, getByLabelText)

4. **Best Practices**
   - Follow AAA pattern (Arrange, Act, Assert)
   - Use descriptive test names
   - Avoid testing implementation details
   - Mock external dependencies
   - Test behavior, not implementation

5. **React 19 Specific**
   - Test Server Components appropriately
   - Test Server Actions
   - Test Suspense boundaries
   - Test Error boundaries
   - Test useOptimistic hook behavior

6. **Coverage Goals**
   - Aim for 80%+ code coverage
   - Cover all critical paths
   - Test error scenarios
   - Test loading states

Output:
- Complete test file with all necessary imports
- Tests organized in describe blocks
- Helper functions for test setup
- Mock data and fixtures
- Comments explaining complex test scenarios

Selected code:
]],
    description = "Generate comprehensive tests with React Testing Library",
    system_prompt = [[You are a testing expert specializing in modern JavaScript/TypeScript testing.
Your expertise covers:
- Vitest and Jest
- React Testing Library best practices
- Test-Driven Development (TDD)
- Integration and E2E testing
- Accessibility testing
- Performance testing
- Mocking strategies

Generate maintainable, readable, and comprehensive tests that catch bugs before production.]],
  },

  RefactorForPerformance = {
    prompt = [[
Refactor the selected code to optimize performance for React 19 and Next.js.

Performance Optimization Checklist:

1. **React Rendering**
   - Eliminate unnecessary re-renders
   - Use React.memo for expensive components
   - Optimize context providers (split contexts)
   - Use useMemo and useCallback appropriately

2. **Bundle Size**
   - Implement code splitting with dynamic imports
   - Tree-shake unused code
   - Reduce dependency sizes
   - Use barrel exports carefully

3. **Server Components (Next.js)**
   - Move non-interactive components to server
   - Reduce client JavaScript bundle
   - Fetch data on server when possible

4. **Data Fetching**
   - Implement parallel data fetching
   - Use Suspense for progressive loading
   - Cache appropriately
   - Implement optimistic updates

5. **Assets**
   - Optimize images (next/image, lazy loading)
   - Implement font optimization
   - Reduce total blocking time

6. **React 19 Features**
   - Use Actions for form submissions
   - Leverage useOptimistic for instant feedback
   - Use transitions for non-urgent updates
   - Implement streaming with Suspense

7. **Measurements**
   - Identify performance metrics before/after
   - Focus on Core Web Vitals (LCP, FID, CLS)
   - Measure actual user impact

Output:
- Optimized code with explanations
- Performance improvement estimates
- Bundle size reduction opportunities
- Monitoring recommendations

Selected code:
]],
    description = "Optimize code for React 19/Next.js performance",
    system_prompt = [[You are a performance optimization expert for React and Next.js.
You specialize in:
- React rendering optimization
- Bundle size reduction
- Core Web Vitals improvement
- Server-side rendering optimization
- Caching strategies
- Profiling and measuring performance

Provide measurable performance improvements with clear explanations.]],
  },

  TypeSafetyEnhancement = {
    prompt = [[
Enhance TypeScript type safety for the selected React/Next.js code.

Type Safety Requirements:

1. **Component Props**
   - Define explicit interfaces for all props
   - Use discriminated unions for variants
   - Make optional props explicit
   - Add JSDoc comments for complex types

2. **React 19 Types**
   - Use correct ReactNode types
   - Type refs properly (React.RefObject, React.ForwardedRef)
   - Type Actions with proper return types
   - Type async components correctly

3. **Next.js Types**
   - Type page params and searchParams
   - Type route handlers correctly
   - Type Server Actions with input/output validation
   - Use proper Metadata types

4. **Generic Components**
   - Implement proper generic constraints
   - Type render props correctly
   - Type higher-order components

5. **Event Handlers**
   - Use proper event types (MouseEvent, ChangeEvent, etc.)
   - Type custom event handlers
   - Type async event handlers

6. **State & Hooks**
   - Type useState with proper initial state
   - Type useReducer with discriminated unions
   - Type custom hooks with generics where appropriate

7. **API & Data**
   - Type API responses with Zod or similar
   - Type form data and validation
   - Use branded types for IDs and sensitive data

8. **Eliminate 'any'**
   - Replace all 'any' with proper types
   - Use 'unknown' when type is truly unknown
   - Add proper type guards

Output:
- Fully typed code with no implicit any
- Type definitions and interfaces
- Zod schemas for runtime validation if needed
- Utility types for reusability

Selected code:
]],
    description = "Enhance TypeScript type safety for React/Next.js",
    system_prompt = [[You are a TypeScript expert specializing in React and Next.js type safety.
Your expertise includes:
- Advanced TypeScript features (generics, conditional types, mapped types)
- React TypeScript patterns
- Runtime type validation (Zod, io-ts)
- Type-safe APIs
- Generic component patterns

Create type-safe, maintainable code that catches errors at compile time.]],
  },

  AccessibilityAudit = {
    prompt = [[
Perform a comprehensive accessibility audit on the selected React component.

Accessibility Checklist (WCAG 2.1 AA):

1. **Semantic HTML**
   - Are semantic elements used (<button>, <nav>, <main>, etc.)?
   - Is heading hierarchy correct (h1 → h2 → h3)?
   - Are lists used for list content?

2. **ARIA**
   - Are ARIA labels present for non-text elements?
   - Is aria-describedby used for form inputs?
   - Are live regions (aria-live) used for dynamic content?
   - Are roles appropriate and necessary?

3. **Keyboard Navigation**
   - Are all interactive elements keyboard accessible?
   - Is focus order logical?
   - Is focus visible?
   - Are keyboard traps avoided?

4. **Forms**
   - Do inputs have associated labels?
   - Are error messages accessible?
   - Is validation feedback announced?
   - Are required fields marked?

5. **Images & Media**
   - Do images have alt text?
   - Are decorative images hidden from screen readers?
   - Are videos captioned?

6. **Color & Contrast**
   - Is color contrast sufficient (4.5:1 for text)?
   - Is information conveyed beyond color alone?

7. **Dynamic Content**
   - Are loading states announced?
   - Are errors announced to screen readers?
   - Are updates to dynamic regions announced?

8. **Focus Management**
   - Is focus moved appropriately in modals?
   - Is focus restored after modal close?
   - Are skip links present for navigation?

Output:
- List of accessibility issues with severity
- Code fixes with ARIA attributes
- Testing recommendations (screen reader, keyboard-only)
- WCAG guideline references

Selected code:
]],
    description = "Audit and improve component accessibility",
    system_prompt = [[You are an accessibility expert specializing in web applications.
Your knowledge includes:
- WCAG 2.1 AA/AAA standards
- ARIA authoring practices
- Screen reader testing
- Keyboard navigation patterns
- Inclusive design principles
- Accessible form patterns

Make web applications usable for everyone, including users with disabilities.]],
  },

  ComponentDocumentation = {
    prompt = [[
Generate comprehensive documentation for the selected React component.

Documentation Requirements:

1. **Component Overview**
   - Purpose and use cases
   - When to use / when not to use
   - Key features

2. **Props Documentation**
   - All props with types
   - Default values
   - Examples of each prop
   - Validation rules

3. **Usage Examples**
   - Basic usage
   - Advanced usage
   - Common patterns
   - Edge cases

4. **Code Examples**
   - TypeScript examples
   - With different prop combinations
   - In real-world scenarios

5. **API Documentation**
   - Exported functions/hooks
   - Return types
   - Side effects

6. **Accessibility**
   - ARIA attributes used
   - Keyboard shortcuts
   - Screen reader behavior

7. **Performance Notes**
   - Rendering behavior
   - Optimization tips
   - Bundle size impact

8. **Testing**
   - How to test the component
   - Common test scenarios

Output format:
- Markdown documentation
- JSDoc comments for code
- Storybook story (if applicable)
- README section

Selected code:
]],
    description = "Generate comprehensive component documentation",
    system_prompt = [[You are a technical documentation expert specializing in component libraries.
Create clear, comprehensive documentation that helps developers understand and use components effectively.]],
  },

  ErrorHandlingImplementation = {
    prompt = [[
Implement comprehensive error handling for the selected React/Next.js code.

Error Handling Requirements:

1. **Error Boundaries**
   - Implement Error Boundary components
   - Add fallback UIs
   - Log errors appropriately
   - Reset error states

2. **Async Error Handling**
   - Catch errors in Server Actions
   - Handle fetch errors
   - Implement retry logic
   - Show user-friendly error messages

3. **Form Validation**
   - Client-side validation
   - Server-side validation
   - Display validation errors
   - Prevent duplicate submissions

4. **Loading States**
   - Show loading indicators
   - Disable interactive elements during loading
   - Handle loading errors

5. **User Feedback**
   - Toast notifications for errors
   - Inline error messages
   - Helpful error descriptions
   - Recovery actions

6. **Error Logging**
   - Log to console in development
   - Send to error tracking service in production
   - Include relevant context
   - Protect sensitive data

7. **Network Errors**
   - Handle offline state
   - Retry failed requests
   - Cache for offline access
   - Show connection status

Output:
- Error Boundary components
- Try-catch blocks where needed
- User-friendly error messages
- Error logging setup
- Recovery mechanisms

Selected code:
]],
    description = "Implement comprehensive error handling",
    system_prompt = [[You are an expert in building resilient React applications.
Implement error handling that provides great UX even when things go wrong.]],
  },

  SecurityAudit = {
    prompt = [[
Perform a security audit on the selected React/Next.js code.

Security Checklist:

1. **XSS Prevention**
   - Are user inputs sanitized?
   - Is dangerouslySetInnerHTML used safely?
   - Are URLs validated before navigation?

2. **Authentication & Authorization**
   - Are routes protected?
   - Are API calls authenticated?
   - Is role-based access implemented?
   - Are tokens stored securely?

3. **Data Validation**
   - Is input validated on client and server?
   - Are file uploads validated?
   - Is SQL injection prevented?

4. **Environment Variables**
   - Are secrets kept out of client bundles?
   - Are NEXT_PUBLIC_ vars used correctly?
   - Are sensitive vars never logged?

5. **API Security**
   - Are API routes protected?
   - Is rate limiting implemented?
   - Are CORS headers correct?
   - Is CSRF protection in place?

6. **Dependencies**
   - Are dependencies up to date?
   - Are there known vulnerabilities?
   - Are supply chain attacks mitigated?

7. **Server Actions**
   - Are actions validated on server?
   - Are permissions checked?
   - Is input sanitized?

Output:
- Security vulnerabilities found
- Risk level for each issue
- Code fixes and mitigations
- Security best practices to follow

Selected code:
]],
    description = "Audit code for security vulnerabilities",
    system_prompt = [[You are a security expert specializing in web application security.
Identify and fix security vulnerabilities to protect users and data.]],
  },

  ConvertToServerComponent = {
    prompt = [[
Convert the selected Client Component to a Server Component where possible.

Conversion Analysis:

1. **Check if conversion is possible**
   - No browser APIs used
   - No event handlers
   - No React hooks (useState, useEffect, etc.)
   - No client-side interactivity

2. **Extract client-only parts**
   - Identify interactive elements
   - Create minimal Client Components for interactivity
   - Keep rest as Server Component

3. **Data fetching**
   - Move data fetching to Server Component
   - Use native fetch with caching
   - Remove client-side data fetching libraries if possible

4. **Benefits explanation**
   - Reduced bundle size
   - Faster page loads
   - Better SEO
   - Server-side data access

If conversion is not fully possible:
- Explain why
- Suggest minimal Client Component boundaries
- Show hybrid approach

Output:
- Converted Server Component
- Extracted Client Components (if needed)
- Updated imports and exports
- Performance improvement estimate

Selected code:
]],
    description = "Convert Client Component to Server Component",
    system_prompt = [[You are an expert in Next.js Server Components architecture.
Maximize server-side rendering benefits while maintaining necessary client interactivity.]],
  },
}

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
  },
  build = "make tiktoken", -- Only on MacOS or Linux
  opts = {
    debug = true, -- Enable debugging
    question_header = "## Fede ",
    model = "claude-sonnet-4.5",
    temperature = 0.2,
    sticky = {
      "@models Using claude-sonnet-4.5",
      "#buffer",
    },

    -- See Configuration section for rest
    window = {
      layout = "vertical",
      relative = "editor",
    },

    prompts = prompts,
    -- Uses visual selection or falls back to buffer
    selection = function(source)
      local select = require("CopilotChat.select")
      return select.visual(source) or select.buffer(source)
    end,
  },
  config = function(_, opts)
    local chat = require("CopilotChat")
    chat.setup(opts)

    local select = require("CopilotChat.select")

    vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
      chat.ask(args.args, { selection = select.visual })
    end, { nargs = "*", range = true })

    -- Inline chat with Copilot
    vim.api.nvim_create_user_command("CopilotChatInline", function(args)
      chat.ask(args.args, {
        selection = select.visual,
        window = {
          layout = "float",
          relative = "cursor",
          width = 1,
          height = 0.4,
          row = 1,
          border = "rounded",
          title = "CopilotChat",
          zindex = 100,
        },
      })
    end, { nargs = "*", range = true })

    -- Restore CopilotChatBuffer
    vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
      chat.ask(args.args, { selection = select.buffer })
    end, { nargs = "*", range = true })

    -- Custom buffer for CopilotChat
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-*",
      callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true

        -- Get current filetype and set it to markdown if the current filetype is copilot-chat
        local ft = vim.bo.filetype
        if ft == "copilot-chat" then
          vim.bo.filetype = "markdown"
        end
      end,
    })
  end,
  event = "VeryLazy",
  keys = {
    -- Show prompts actions with telescope
    {
      mode = "n",
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt({
          context = { "buffer" },
        })
      end,
      desc = "CopilotChat - Prompt actions",
    },
    {
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt()
      end,
      mode = "x",
      desc = "CopilotChat - Prompt actions",
    },
    -- Code related commands
    { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
    { "<leader>aT", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
    { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
    { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
    { "<leader>arv", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
    { mode = "n", "<leader>af", ":CopilotChatFix<CR>", desc = "CopilotChat - Fix" },
    { mode = "n", "<leader>ao", ":CopilotChatOptimize<CR>", desc = "CopilotChat - Optimize" },
    -- Fix the issue with diagnostic
    { "<leader>aF", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Diagnostic" },
    -- Clear buffer and chat history
    { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
    -- Toggle Copilot Chat Vsplit
    { "<leader>cT", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
    -- Copilot Chat Models
    { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
    -- Copilot Chat Agents
    { "<leader>aa", "<cmd>CopilotChatAgents<cr>", desc = "CopilotChat - Select Agents" },
    -- Chat with Copilot in visual mode
    {
      "<leader>av",
      ":CopilotChatVisual",
      mode = "x",
      desc = "CopilotChat - Open in vertical split",
    },
    {
      "<leader>aI",
      ":CopilotChatInline",
      mode = "x",
      desc = "CopilotChat - Inline chat",
    },
    -- Custom input for CopilotChat
    {
      "<leader>ai",
      function()
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then
          vim.cmd("CopilotChat " .. input)
        end
      end,
      desc = "CopilotChat - Ask input",
    },

    -- Generate commit message based on the git diff
    {
      mode = {
        "n",
        "i",
      },
      "<leader>am",
      "<cmd>CopilotChatCommit<cr>",
      desc = "CopilotChat - Generate commit message for all changes",
    },
    {
      "<leader>aM",
      function()
        local chat = require("CopilotChat")
        local response = chat.ask("", prompts.Commit)
        if response then
          vim.api.nvim_put(vim.split(response, "\n"), "l", true, true)
        end
      end,
      desc = "CopilotChat - Generate commit message for all changes",
    },

    {
      mode = "n",
      "<leader>aq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end,
      desc = "CopilotChat - Quick chat",
    },
    {
      mode = "n",
      "<leader>ac",
      ": CopilotChat<CR>",
      desc = "Copilot Chat",
    },
  },
}
