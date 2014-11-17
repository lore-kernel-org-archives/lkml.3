Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKQSxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:53:04 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:53689 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKQSxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:53:02 -0500
MIME-Version: 1.0
From: Terence Eden <terence.eden@gmail.com>
Date: Mon, 17 Nov 2014 18:52:40 +0000
Message-ID: <CABV2FHjqGTBWjNqT6g=v2nW1rXg4oGNrYvbAZUXxpE_Wn_UvUA@mail.gmail.com>
Subject: [PATCH] crypto: Fix a typo in ahash.c
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        clabbe.montjoie@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Terence Eden <terence.eden@gmail.com>

"its" == "something belong to it". "it's" == "it is", "it has", "it
was", etc. Sorry - just bugged me as I was reading the code.
(Resubmitting - hopefully correctly!)

Signed-off-by: Terence Eden <terence.eden@gmail.com>
---
 crypto/ahash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f6a36a5..ffbcda3 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -271,7 +271,7 @@ static int ahash_save_req(struct ahash_request
*req, crypto_completion_t cplt)
     /*
      * WARNING: We do not backup req->priv here! The req->priv
      *          is for internal use of the Crypto API and the
-     *          user must _NOT_ _EVER_ depend on it's content!
+     *          user must _NOT_ _EVER_ depend on its content!
      */

     req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
-- 
1.9.1
