Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3JGOiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:38:54 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:33898 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab3JGOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:38:53 -0400
From: Stefan Beller <stefanbeller@googlemail.com>
To: tytso@mit.edu, linux-kernel@vger.kernel.org
Cc: Stefan Beller <stefanbeller@googlemail.com>
Subject: [PATCH] random.c: fix a typo in comments
Date: Mon,  7 Oct 2013 16:38:49 +0200
Message-Id: <1381156729-1814-1-git-send-email-stefanbeller@googlemail.com>
X-Mailer: git-send-email 1.8.4.1.469.gb38b9db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also removes (trailing) tabs from an empty line.

Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
---
 drivers/char/random.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7737b5b..a8457f2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -382,7 +382,7 @@ static struct poolinfo {
  * modulo the generator polymnomial.  Now, for random primitive polynomials,
  * this is a universal class of hash functions, meaning that the chance
  * of a collision is limited by the attacker's knowledge of the generator
- * polynomail, so if it is chosen at random, an attacker can never force
+ * polynomial, so if it is chosen at random, an attacker can never force
  * a collision.  Here, we use a fixed polynomial, but we *can* assume that
  * ###--> it is unknown to the processes generating the input entropy. <-###
  * Because of this important property, this is a good, collision-resistant
@@ -1078,7 +1078,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
 
 		if (!arch_get_random_long(&v))
 			break;
-		
+
 		memcpy(p, &v, chunk);
 		p += chunk;
 		nbytes -= chunk;
-- 
1.8.4.1.469.gb38b9db

