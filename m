Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3JQPj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:39:27 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56360 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3JQPjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:39:25 -0400
From: Siddharth Goel <siddharth98391@gmail.com>
To: herbert@gondor.hengli.com.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Siddharth Goel <siddharth98391@gmail.com>
Subject: [PATCH] [CRYPTO] kconfig: Corrected a typo
Date: Thu, 17 Oct 2013 23:39:11 +0800
Message-Id: <1382024351-23743-1-git-send-email-siddharth98391@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected a typo in option description in Kconfig

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=60848

Signed-off-by: Siddharth Goel <siddharth98391@gmail.com>
---
 crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69ce573..84698cf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1084,7 +1084,7 @@ config CRYPTO_SERPENT
 
 	  Keys are allowed to be from 0 to 256 bits in length, in steps
 	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
-	  variant of Serpent for compatibility with old kerneli.org code.
+	  variant of Serpent for compatibility with old kernel.org code.
 
 	  See also:
 	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
-- 
1.7.0.4

