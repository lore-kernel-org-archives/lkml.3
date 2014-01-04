Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaADCnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:43:31 -0500
Received: from mout.gmx.net ([212.227.17.22]:58129 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbaADCnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:43:05 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 07/15] char: tpm: nuvoton: remove unused variable
Date: Sat,  4 Jan 2014 03:44:41 +0100
Message-Id: <1388803489-13258-7-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:OvCvsoG/3ecgTCiHjaDSdfGN1an0f39Nc/1S7eoGMQbY/YJZF3O
 Unnh43Khk+/c5CZhztYwAvbRdM2i86nL+9xZ4bwLVs9qD9KfUm1+NIAtZpoTWur27Xjs00u
 +IUyZsRRhPpELXN5CIAql8pjPLfq2Kqc7BKOOZK+/ddojl8penbmfBuuoelYO3bq4e+qYBY
 IcLZWwxplAli0lnbgxwUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

“wait” wait queue is defined but never used in the function, thus
it can be removed.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_i2c_nuvoton.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 6276fea..4f5ac25 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -178,7 +178,6 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 {
 	if (chip->vendor.irq && queue) {
 		s32 rc;
-		DEFINE_WAIT(wait);
 		struct priv_data *priv = chip->vendor.priv;
 		unsigned int cur_intrs = priv->intrs;
 
-- 
1.8.1.5

