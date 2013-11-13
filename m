Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab3KMIH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:07:26 -0500
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:49541 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758727Ab3KMIHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:07:18 -0500
X-AuditID: 12074424-b7fa56d000000be4-74-52833335c27f
Date: Wed, 13 Nov 2013 03:07:14 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] random: fix typos / spelling errors in comments
Message-ID: <20131113080714.GO16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsUixG6nrmtq3BxkcP46l8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mq4v/0sS8F2norbWzQbGL9ydjFyckgImEhMa13JAmGLSVy4t56t
	i5GLQ0hgNpPEx8XLmEESQgIbGSVWt/pC2L8YJW4fVASxWQRUJaa+Wc8OYrMJKEj8mL8OrF5E
	QFli1cxNTCA2M1D8171NrCC2sICLxN4vO8GW8QqYSUyc9JYJYqaBxMb9E5gh4oISJ2c+YYHo
	1ZK48e8lUA0HkC0tsfwfB0iYU8BQYtKGo2AjRQVUJKac3MY2gVFwFpLuWUi6ZyF0L2BkXsUo
	m5JbpZubmJlTnJqsW5ycmJeXWqRrrpebWaKXmlK6iREcoi4qOxibDykdYhTgYFTi4bWIaQoS
	Yk0sK67MPcQoycGkJMrrpNMcJMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmE94AwUI43JbGyKrUo
	HyYlzcGiJM57i8M+SEggPbEkNTs1tSC1CCYrw8GhJMF72hCoUbAoNT21Ii0zpwQhzcTBCTKc
	B2j4TJAa3uKCxNzizHSI/ClGRSlx3lyQhABIIqM0D64XlkJeMYoDvSLMOxukigeYfuC6XwEN
	ZgIabFHcBDK4JBEhJdXAGLUvwtXUPUfV9vzkbco5wlc+/27u3PRW971j8O9sjsfsj9+zPbvU
	f2Grpp9b90/Pr19FNRg6+g+WHTvN5FSV8ltwycz71q8/ceUUTKy60fyCuS6zYoN3kEvDOdM5
	VU+/vGLadGFX/jq7OR/EVL0My/a0RkYX3dpQnhWedOF8+FTvnMZDy37oK7EUZyQaajEXFScC
	ACx23Kn8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index cdf4cfb..ed72be5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -308,7 +308,7 @@ static int random_read_wakeup_thresh = 64;
 static int random_write_wakeup_thresh = 28 * OUTPUT_POOL_WORDS;
 
 /*
- * The minimum number of seconds between urandom pool resending.  We
+ * The minimum number of seconds between urandom pool reseeding.  We
  * do this to limit the amount of entropy that can be drained from the
  * input pool even if there are heavy demands on /dev/urandom.
  */
@@ -325,7 +325,7 @@ static int random_min_urandom_seed = 60;
  * Register.  (See M. Matsumoto & Y. Kurita, 1992.  Twisted GFSR
  * generators.  ACM Transactions on Modeling and Computer Simulation
  * 2(3):179-194.  Also see M. Matsumoto & Y. Kurita, 1994.  Twisted
- * GFSR generators II.  ACM Transactions on Mdeling and Computer
+ * GFSR generators II.  ACM Transactions on Modeling and Computer
  * Simulation 4:254-266)
  *
  * Thanks to Colin Plumb for suggesting this.
@@ -1040,7 +1040,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
 
 	/*
-	 * If we have a architectural hardware random number
+	 * If we have an architectural hardware random number
 	 * generator, mix that in, too.
 	 */
 	for (i = 0; i < LONGS(20); i++) {
-- 
1.8.3.2

