Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaHVQdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:33:50 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:62482 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbaHVQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:33:47 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: crypto: mv_cesa.h: Add missing #define
Date: Fri, 22 Aug 2014 18:33:37 +0200
Message-Id: <1408725217-2342-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly this was meant to be an include guard, but the #define was
missing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/crypto/mv_cesa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/mv_cesa.h b/drivers/crypto/mv_cesa.h
index 08fcb11..9249d3e 100644
--- a/drivers/crypto/mv_cesa.h
+++ b/drivers/crypto/mv_cesa.h
@@ -1,4 +1,5 @@
 #ifndef __MV_CRYPTO_H__
+#define __MV_CRYPTO_H__
 
 #define DIGEST_INITIAL_VAL_A	0xdd00
 #define DIGEST_INITIAL_VAL_B	0xdd04
-- 
2.0.4

