Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbaGDOEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:04:52 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47205 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703AbaGDOEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:04:50 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 2/2] crypto: qce: add dependancy to Kconfig
Date: Fri,  4 Jul 2014 17:03:30 +0300
Message-Id: <1404482610-25608-3-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1404482610-25608-1-git-send-email-svarbanov@mm-sol.com>
References: <1404482610-25608-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make qce crypto driver depend on ARCH_QCOM and make
possible to test driver compilation.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3e5186e..5ef9ec9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -422,6 +422,7 @@ source "drivers/crypto/qat/Kconfig"
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
+	depends on ARCH_QCOM || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_ECB
-- 
1.7.0.4

