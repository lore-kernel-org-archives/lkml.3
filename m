Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3FQQ0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:26:43 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40802 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815Ab3FQQ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:26:41 -0400
From: Lorenz Haspel <lorenz@badgers.com>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Lorenz Haspel <lorenz@badgers.com>
Subject: [PATCH 2/4] silicom: checkpatch: fixed whitespace errors
Date: Mon, 17 Jun 2013 18:26:24 +0200
Message-Id: <1371486386-8043-2-git-send-email-lorenz@badgers.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
References: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

started cleanfile
also fixed some other whitespace errors cleanfile didn't find

Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
---
 drivers/staging/silicom/bpctl_mod.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index d2debe8..1461130 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -1421,8 +1421,8 @@ static int wdt_pulse(bpctl_dev_t *pbpctl_dev)
 				(ctrl_ext &
 				 ~(BP10G_MCLK_DATA_OUT | BP10G_MDIO_DATA_OUT)));
 	}
-	if ((pbpctl_dev->wdt_status == WDT_STATUS_EN)	/*&&
-							   (pbpctl_dev->bp_ext_ver<PXG4BPFI_VER) */)
+	if ((pbpctl_dev->wdt_status == WDT_STATUS_EN))
+		/*&& (pbpctl_dev->bp_ext_ver<PXG4BPFI_VER) */
 		pbpctl_dev->bypass_wdt_on_time = jiffies;
 #ifdef BP_SYNC_FLAG
 	spin_unlock_irqrestore(&pbpctl_dev->bypass_wr_lock, flags);
@@ -6652,7 +6652,7 @@ static void find_fw(bpctl_dev_t *dev)
 			    ioremap(mmio_start, mmio_len);
 
 			dev->bp_fw_ver = bypass_fw_ver(dev);
-			if (dev-> bp_fw_ver == 0xa8)
+			if (dev->bp_fw_ver == 0xa8)
 				break;
 		}
 	}
-- 
1.7.10.4

