Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3FQOVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:21:09 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39791 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753663Ab3FQOVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:21:06 -0400
From: Lorenz Haspel <lorenz@badgers.com>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Lorenz Haspel <lorenz@badgers.com>,
        Michael Banken <michael.banken@mathe.stud.uni-erlangen>
Subject: [PATCH 2/5] silicom: checkpatch: fixed whitespace errors
Date: Mon, 17 Jun 2013 16:20:14 +0200
Message-Id: <1371478817-28357-2-git-send-email-lorenz@badgers.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371478817-28357-1-git-send-email-lorenz@badgers.com>
References: <1371478817-28357-1-git-send-email-lorenz@badgers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

started cleanfile
also fixed some other whitespace errors cleanfile didn't find

Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen>
Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
---
 drivers/staging/silicom/bpctl_mod.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 69100c9..2420383 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -43,12 +43,12 @@ MODULE_DESCRIPTION(BP_MOD_DESCR);
 MODULE_VERSION(BP_MOD_VER);
 spinlock_t bpvm_lock;
 
-#define lock_bpctl() 					\
+#define lock_bpctl()					\
 if (down_interruptible(&bpctl_sema)) {			\
 	return -ERESTARTSYS;				\
 }							\
 
-#define unlock_bpctl() 					\
+#define unlock_bpctl()					\
 	up(&bpctl_sema);
 
 /* Media Types */
@@ -1421,8 +1421,8 @@ static int wdt_pulse(bpctl_dev_t *pbpctl_dev)
 				(ctrl_ext &
 				 ~(BP10G_MCLK_DATA_OUT | BP10G_MDIO_DATA_OUT)));
 	}
-	if ((pbpctl_dev->wdt_status == WDT_STATUS_EN)	/*&&
-							   (pbpctl_dev->bp_ext_ver<PXG4BPFI_VER) */ )
+	if ((pbpctl_dev->wdt_status == WDT_STATUS_EN))
+		/*&& (pbpctl_dev->bp_ext_ver<PXG4BPFI_VER) */
 		pbpctl_dev->bypass_wdt_on_time = jiffies;
 #ifdef BP_SYNC_FLAG
 	spin_unlock_irqrestore(&pbpctl_dev->bypass_wr_lock, flags);
@@ -4343,7 +4343,7 @@ int get_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-#ifdef  BP_SELF_TEST
+#ifdef BP_SELF_TEST
 
 int set_bp_self_test(bpctl_dev_t *pbpctl_dev, unsigned int param)
 {
@@ -5461,9 +5461,9 @@ static long device_ioctl(struct file *file,	/* see include/linux/fs.h */
 		return -1;
 	}
 
-/*    	preempt_disable();
+/*	preempt_disable();
 	rcu_read_lock();
-      	spin_lock_irqsave(&bpvm_lock, flags);
+	spin_lock_irqsave(&bpvm_lock, flags);
 */
 	if ((bpctl_cmd.in_param[5]) ||
 	    (bpctl_cmd.in_param[6]) || (bpctl_cmd.in_param[7]))
@@ -5810,7 +5810,7 @@ static const struct file_operations Fops = {
 };
 
 #ifndef PCI_DEVICE
-#define PCI_DEVICE(vend,dev) \
+#define PCI_DEVICE(vend, dev) \
 	.vendor = (vend), .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 #endif
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

