Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaDNM5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:57:51 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:43113 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbaDNM5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:57:50 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-arm-msm@vger.kernel.org,
        Mona Hossain <mhossain@codeaurora.org>,
        Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
        Zhen Kong <zkong@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [RFC PATCH v2 7/9] crypto: qce: Adds Makefile to build the driver
Date: Mon, 14 Apr 2014 15:48:43 +0300
Message-Id: <1397479725-20954-8-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
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

