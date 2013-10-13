Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3JMIiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 04:38:16 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52089 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3JMIiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 04:38:14 -0400
From: Stefan Beller <stefanbeller@googlemail.com>
To: tytso@mit.edu, linux-kernel@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org
Cc: Stefan Beller <stefanbeller@googlemail.com>
Subject: [PATCH] random.c: fix a typo in comments
Date: Sun, 13 Oct 2013 10:38:35 +0200
Message-Id: <1381653515-19908-1-git-send-email-stefanbeller@googlemail.com>
X-Mailer: git-send-email 1.8.4.1.471.g53f64e4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also removes (trailing) tabs from an empty line.

Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
---
 drivers/char/random.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 57d4b15..294a59c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -385,7 +385,7 @@ static struct poolinfo {
  * modulo the generator polymnomial.  Now, for random primitive polynomials,
  * this is a universal class of hash functions, meaning that the chance
  * of a collision is limited by the attacker's knowledge of the generator
- * polynomail, so if it is chosen at random, an attacker can never force
+ * polynomial, so if it is chosen at random, an attacker can never force
  * a collision.  Here, we use a fixed polynomial, but we *can* assume that
  * ###--> it is unknown to the processes generating the input entropy. <-###
  * Because of this important property, this is a good, collision-resistant
@@ -1073,7 +1073,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
 
 		if (!arch_get_random_long(&v))
 			break;
-		
+
 		memcpy(p, &v, chunk);
 		p += chunk;
 		nbytes -= chunk;
-- 
1.8.4.1.471.g53f64e4.dirty

