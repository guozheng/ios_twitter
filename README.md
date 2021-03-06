ios_twitter
===========

a simple twitter client for iOS

User Stories
============

   * User can sign in using OAuth login flow
   * User can view last 20 tweets from their home timeline
   * The current signed in user will be persisted across restarts
   * In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
   * User can pull to refresh
   * User can compose a new tweet by tapping on a compose button.
   * User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
   * Optional: When composing, you should have a countdown in the upper right for the tweet limit.
   * Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
   * Optional: Retweeting and favoriting should increment the retweet and favorite count.
   * Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
   * Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
   * Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

Time Spent: 15 hrs
==================

Screencast
==========

The reply, retweet, favoriate buttons and pull to refresh are missing, others are working fine.

<img src="screenshots/screencast.gif" alt="Twitter iOS app" width="334px" height="579px" />
