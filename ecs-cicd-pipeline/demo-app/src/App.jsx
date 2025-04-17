import { useState } from 'react';
import './App.css';

function App() {
  const [quote, setQuote] = useState('');
  const [loading, setLoading] = useState(false);

  return (
    <>
      <main className="min-h-screen flex items-center justify-center bg-gray-100 px-4">
        <div className="max-w-2xl text-center bg-white p-10 rounded-2xl shadow-xl border border-gray-200">
          <h1 className="text-3xl font-bold text-gray-800 mb-4">
            Container Orchestration using ECR, ECS and CodePipeline
          </h1>
          <p className="text-gray-600 mb-6">
            Version 1 — A production-ready setup for deploying containerized applications on AWS
            with a fully automated CI/CD pipeline.
          </p>
        </div>
      </main>
    </>
  );
}

export default App;
