Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaFKDa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:30:27 -0400
Received: from imap.thunk.org ([74.207.234.97]:60935 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbaFKDaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:30:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 0/3] random driver improvements
Date: Tue, 10 Jun 2014 23:30:17 -0400
Message-Id: <1402457420-2527-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After going through a very long thread, and trying to work out things in
words, I was frustrated enough that I decided a good way to improve the
conversation was to do it in code instead of words.

I don't think any of this should be controversial...

						- Ted

Theodore Ts'o (3):
  random: always update the entropy pool under the spinlock
  random: remove unneeded hash of a portion of the entropy pool
  random: only update the last_pulled time if we actually transferred
    entropy

 drivers/char/random.c | 98 ++++++++++++++++++++++++---------------------------
 1 file changed, 46 insertions(+), 52 deletions(-)

-- 
2.0.0

