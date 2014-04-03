Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaDCQXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:23:34 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56238 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaDCQXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:23:32 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 7/9] crypto: qce: Adds Makefile to build the driver
Date: Thu,  3 Apr 2014 19:18:04 +0300
Message-Id: <1396541886-10966-8-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds Makefile needed to build the driver.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 drivers/crypto/qce/Makefile

diff --git a/drivers/crypto/qce/Makefile b/drivers/crypto/qce/Makefile
new file mode 100644
index 000000000000..348dc3173afa
--- /dev/null
+++ b/drivers/crypto/qce/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_CRYPTO_DEV_QCE) += qcrypto.o
+qcrypto-objs := core.o \
+		common.o \
+		dma.o \
+		sha.o \
+		ablkcipher.o
-- 
1.8.4.4

