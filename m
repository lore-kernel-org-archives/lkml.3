Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbbA2KiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:38:07 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755510AbbA2JAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 138/176] crypto: sha256_ssse3 - use correct module alias for sha224
Date: Wed, 28 Jan 2015 15:29:28 +0100
Message-Id: <262038b46f3792b641640e8ca3e6538a6b83a61b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7d444909a25ed4a9dbc546bf9528c8d2e3bf3752 upstream.

Commit a710f761f (crypto: sha256_ssse3 - add sha224 support) attempted to add
MODULE_ALIAS for SHA-224, but it ended up being "sha384", probably because
mix-up with previous commit 340991e30 (crypto: sha512_ssse3 - add sha384
support). Patch corrects module alias to "sha224".

Reported-by: Pierre-Mayeul Badaire <pierre-mayeul.badaire@m4x.org>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index e52947f80e68..f248546da1ca 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -319,4 +319,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm, Supplemental SSE3 accelerated");
 
 MODULE_ALIAS("sha256");
-MODULE_ALIAS("sha384");
+MODULE_ALIAS("sha224");
-- 
2.2.2

