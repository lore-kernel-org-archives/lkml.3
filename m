Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaCQHkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:40:47 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:56851 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbaCQHkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:40:45 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: [PATCH v2 4/6] compile the DRBG code
Date: Mon, 17 Mar 2014 08:37:33 +0100
Message-ID: <3319954.xS7rx9A3Ha@myon.chronox.de>
User-Agent: KMail/4.12.3 (Linux/3.13.6-200.fc20.x86_64; KDE/4.12.3; x86_64; ; )
In-Reply-To: <2589470.EoGAcF9qRN@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <2831049.lrfGvkkTou@myon.chronox.de> <2589470.EoGAcF9qRN@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---

diff --git a/crypto/Makefile b/crypto/Makefile
index b29402a..0d63373 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
+obj-$(CONFIG_CRYTPO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
-- 
1.8.5.3


