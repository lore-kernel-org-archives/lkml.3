Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab3KGX5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:57:45 -0500
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34]:53397 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3KGX5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:57:38 -0500
X-AuditID: 12074422-b7f028e000003e57-6b-527c28f13e11
Date: Thu, 7 Nov 2013 18:57:35 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] random: fix typos / spelling errors in comments
Message-ID: <20131107235735.GD16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsUixCmqrftRoybI4MB0SYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXxoOcQa8FV/oq7K34yNzDu4uli5OCQEDCRWL9As4uRE8gUk7hw
	bz1bFyMXh5DAbCaJZ19us0A4GxglnvT9ZgapEhL4ySix9X0ZiM0ioCLx5dQZsDibgILEj/nr
	wGwRAWWJVTM3MYHYzEDxX/c2sYLYwgJuElc29DCC2LwCZhKP1zQzQsw0kPg5/S0LRFxQ4uTM
	JywQvVoSN/69ZAI5lFlAWmL5Pw6QMKeAoUR78xWwkaJAJ0w5uY1tAqPgLCTds5B0z0LoXsDI
	vIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXVC83s0QvNaV0EyMoSNldlHYw/jyodIhRgINRiYe3
	4EJ1kBBrYllxZe4hRkkOJiVR3onqNUFCfEn5KZUZicUZ8UWlOanFhxglOJiVRHifKQLleFMS
	K6tSi/JhUtIcLErivLc47IOEBNITS1KzU1MLUotgsjIcHEoSvItAhgoWpaanVqRl5pQgpJk4
	OEGG8wANXwJSw1tckJhbnJkOkT/FqCglzjsHJCEAksgozYPrhSWRV4ziQK8I8xaDVPEAExBc
	9yugwUxAg0N+VYIMLklESEk1MDK6PurZtSlHOcXBZO7qiWuz83xS2z2/WqVcNLYrmVEa8uO+
	2bqm2C1LZ4kdmWvabHbT4ug2EWmfA9O+tr45p88a8+TkYfYole78f7c1C++scDc8+TVMbM69
	DavfflBoOM6XZcx0V0t5y92bOwyC5v3c/e7d2zPp0UZrYmM+u1XEcVftzNVwzldiKc5INNRi
	LipOBADQ1DCw/QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7a744d3..ef3e15b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -348,12 +348,12 @@ static struct poolinfo {
 
 /*
  * For the purposes of better mixing, we use the CRC-32 polynomial as
- * well to make a twisted Generalized Feedback Shift Reigster
+ * well to make a twisted Generalized Feedback Shift Register
  *
  * (See M. Matsumoto & Y. Kurita, 1992.  Twisted GFSR generators.  ACM
  * Transactions on Modeling and Computer Simulation 2(3):179-194.
  * Also see M. Matsumoto & Y. Kurita, 1994.  Twisted GFSR generators
- * II.  ACM Transactions on Mdeling and Computer Simulation 4:254-266)
+ * II.  ACM Transactions on Modeling and Computer Simulation 4:254-266)
  *
  * Thanks to Colin Plumb for suggesting this.
  *
@@ -382,7 +382,7 @@ static struct poolinfo {
  * modulo the generator polymnomial.  Now, for random primitive polynomials,
  * this is a universal class of hash functions, meaning that the chance
  * of a collision is limited by the attacker's knowledge of the generator
- * polynomail, so if it is chosen at random, an attacker can never force
+ * polynomial, so if it is chosen at random, an attacker can never force
  * a collision.  Here, we use a fixed polynomial, but we *can* assume that
  * ###--> it is unknown to the processes generating the input entropy. <-###
  * Because of this important property, this is a good, collision-resistant
@@ -943,7 +943,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	hash.w[2] ^= rol32(hash.w[2], 16);
 
 	/*
-	 * If we have a architectural hardware random number
+	 * If we have an architectural hardware random number
 	 * generator, mix that in, too.
 	 */
 	for (i = 0; i < LONGS(EXTRACT_SIZE); i++) {
-- 
1.8.3.2

