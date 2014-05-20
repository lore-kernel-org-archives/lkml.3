Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaETOAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:00:39 -0400
Received: from tex.lwn.net ([70.33.254.29]:33372 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbaETOAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:00:35 -0400
Date: Tue, 20 May 2014 08:00:33 -0600
From: Jake Edge <jake@lwn.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Cooper <jason@lakedaemon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anton Saraev <antonysaraev@gmail.com>
Subject: [PATCH 2/3] staging/skein: comment typos
Message-ID: <20140520080033.2e54e6d0@chukar.edge2.net>
In-Reply-To: <20140520075612.220a13ae@chukar.edge2.net>
References: <20140520075612.220a13ae@chukar.edge2.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix some comment typos

Signed-off-by: Jake Edge <jake@lwn.net>
---

against staging-next branch of staging tree

 drivers/staging/skein/threefish_api.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/skein/threefish_api.h b/drivers/staging/skein/threefish_api.h
index 2fce154..8d5ddf8 100644
--- a/drivers/staging/skein/threefish_api.h
+++ b/drivers/staging/skein/threefish_api.h
@@ -12,7 +12,7 @@
  * follow the openSSL design but at the same time take care of some Threefish
  * specific behaviour and possibilities.
  *
- * These are the low level functions that deal with Threefisch blocks only.
+ * These are the low level functions that deal with Threefish blocks only.
  * Implementations for cipher modes such as ECB, CFB, or CBC may use these
  * functions.
  *
@@ -77,9 +77,9 @@ void threefish_set_key(struct threefish_key *key_ctx,
 		       u64 *key_data, u64 *tweak);
 
 /**
- * Encrypt Threefisch block (bytes).
+ * Encrypt Threefish block (bytes).
  *
- * The buffer must have at least the same length (number of bits) aas the
+ * The buffer must have at least the same length (number of bits) as the
  * state size for this key. The function uses the first @c state_size bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
@@ -95,9 +95,9 @@ void threefish_encrypt_block_bytes(struct threefish_key *key_ctx, u8 *in,
 				   u8 *out);
 
 /**
- * Encrypt Threefisch block (words).
+ * Encrypt Threefish block (words).
  *
- * The buffer must have at least the same length (number of bits) aas the
+ * The buffer must have at least the same length (number of bits) as the
  * state size for this key. The function uses the first @c state_size bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
@@ -115,9 +115,9 @@ void threefish_encrypt_block_words(struct threefish_key *key_ctx, u64 *in,
 				   u64 *out);
 
 /**
- * Decrypt Threefisch block (bytes).
+ * Decrypt Threefish block (bytes).
  *
- * The buffer must have at least the same length (number of bits) aas the
+ * The buffer must have at least the same length (number of bits) as the
  * state size for this key. The function uses the first @c state_size bits
  * of the input buffer, decrypts them and stores the result in the output
  * buffer
@@ -133,9 +133,9 @@ void threefish_decrypt_block_bytes(struct threefish_key *key_ctx, u8 *in,
 				   u8 *out);
 
 /**
- * Decrypt Threefisch block (words).
+ * Decrypt Threefish block (words).
  *
- * The buffer must have at least the same length (number of bits) aas the
+ * The buffer must have at least the same length (number of bits) as the
  * state size for this key. The function uses the first @c state_size bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
-- 
1.9.0



-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
