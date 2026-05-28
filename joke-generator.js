/**
 * Random Joke Generator
 * Uses the JokeAPI to fetch random jokes
 * No authentication required
 */

const https = require('https');

/**
 * Fetch a random joke from JokeAPI
 * @param {string} type - Type of joke: 'single' or 'twopart' (default: 'any')
 * @returns {Promise<string>} - The joke text
 */
function getRandomJoke(type = 'any') {
  return new Promise((resolve, reject) => {
    const url = `https://v2.jokeapi.dev/joke/${type}`;

    https.get(url, (res) => {
      let data = '';

      // Collect response chunks
      res.on('data', (chunk) => {
        data += chunk;
      });

      // Parse and return joke
      res.on('end', () => {
        try {
          const jokeData = JSON.parse(data);

          if (jokeData.error) {
            reject(new Error(`API Error: ${jokeData.message}`));
            return;
          }

          // Format the joke based on type
          let joke = '';
          if (jokeData.type === 'single') {
            joke = jokeData.joke;
          } else if (jokeData.type === 'twopart') {
            joke = `${jokeData.setup}\n\n${jokeData.delivery}`;
          }

          resolve(joke);
        } catch (error) {
          reject(new Error(`Failed to parse API response: ${error.message}`));
        }
      });
    }).on('error', (error) => {
      reject(new Error(`HTTP Request failed: ${error.message}`));
    });
  });
}

/**
 * Get multiple random jokes
 * @param {number} count - Number of jokes to fetch (default: 5)
 * @param {string} type - Type of joke (default: 'any')
 * @returns {Promise<string[]>} - Array of jokes
 */
async function getMultipleJokes(count = 5, type = 'any') {
  const jokes = [];
  for (let i = 0; i < count; i++) {
    try {
      const joke = await getRandomJoke(type);
      jokes.push(joke);
    } catch (error) {
      jokes.push(`Error fetching joke ${i + 1}: ${error.message}`);
    }
  }
  return jokes;
}

/**
 * Main demo function
 */
async function main() {
  console.log('🎭 Random Joke Generator\n');
  console.log('===============================\n');

  try {
    // Get a single random joke
    console.log('📝 Fetching a random joke...\n');
    const singleJoke = await getRandomJoke();
    console.log('Joke:');
    console.log(singleJoke);
    console.log('\n===============================\n');

    // Get 3 more jokes
    console.log('📚 Fetching 3 more jokes...\n');
    const multipleJokes = await getMultipleJokes(3);
    multipleJokes.forEach((joke, index) => {
      console.log(`Joke ${index + 1}:`);
      console.log(joke);
      console.log('---');
    });

    console.log('\n✅ All jokes fetched successfully!');
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

// Run the demo
main();

// Export functions for use as module
module.exports = {
  getRandomJoke,
  getMultipleJokes
};
