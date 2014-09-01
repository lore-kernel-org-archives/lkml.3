Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaIAPoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:44:16 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40849 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaIAPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:44:14 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 3/8] staging: rtl8188eu: HalPwrSeqCmd.h: Remove unnecessary comments.
Date: Mon,  1 Sep 2014 21:13:38 +0530
Message-Id: <1409586223-5915-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
References: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h |  108 +++++++---------------
 1 file changed, 35 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h b/drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h
index fc24ce4..980a497 100644
--- a/drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h
+++ b/drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h
@@ -22,77 +22,41 @@
 
 #include <drv_types.h>
 
-/*---------------------------------------------*/
-/* 3 The value of cmd: 4 bits */
-/*---------------------------------------------*/
-#define PWR_CMD_READ			0x00
-     /*  offset: the read register offset */
-     /*  msk: the mask of the read value */
-     /*  value: N/A, left by 0 */
-     /*  note: dirver shall implement this function by read & msk */
-
-#define PWR_CMD_WRITE			0x01
-     /*  offset: the read register offset */
-     /*  msk: the mask of the write bits */
-     /*  value: write value */
-     /*  note: driver shall implement this cmd by read & msk after write */
-
-#define PWR_CMD_POLLING			0x02
-     /*  offset: the read register offset */
-     /*  msk: the mask of the polled value */
-     /*  value: the value to be polled, masked by the msd field. */
-     /*  note: driver shall implement this cmd by */
-     /*  do{ */
-     /*  if ( (Read(offset) & msk) == (value & msk) ) */
-     /*  break; */
-     /*  } while (not timeout); */
-
-#define PWR_CMD_DELAY			0x03
-     /*  offset: the value to delay */
-     /*  msk: N/A */
-     /*  value: the unit of delay, 0: us, 1: ms */
-
-#define PWR_CMD_END			0x04
-     /*  offset: N/A */
-     /*  msk: N/A */
-     /*  value: N/A */
-
-/*---------------------------------------------*/
-/* 3 The value of base: 4 bits */
-/*---------------------------------------------*/
-   /*  define the base address of each block */
-#define PWR_BASEADDR_MAC		0x00
-#define PWR_BASEADDR_USB		0x01
-#define PWR_BASEADDR_PCIE		0x02
-#define PWR_BASEADDR_SDIO		0x03
-
-/*---------------------------------------------*/
-/* 3 The value of interface_msk: 4 bits */
-/*---------------------------------------------*/
-#define	PWR_INTF_SDIO_MSK		BIT(0)
-#define	PWR_INTF_USB_MSK		BIT(1)
-#define	PWR_INTF_PCI_MSK		BIT(2)
-#define	PWR_INTF_ALL_MSK		(BIT(0)|BIT(1)|BIT(2)|BIT(3))
-
-/*---------------------------------------------*/
-/* 3 The value of fab_msk: 4 bits */
-/*---------------------------------------------*/
-#define	PWR_FAB_TSMC_MSK		BIT(0)
-#define	PWR_FAB_UMC_MSK			BIT(1)
-#define	PWR_FAB_ALL_MSK			(BIT(0)|BIT(1)|BIT(2)|BIT(3))
-
-/*---------------------------------------------*/
-/* 3 The value of cut_msk: 8 bits */
-/*---------------------------------------------*/
-#define	PWR_CUT_TESTCHIP_MSK		BIT(0)
-#define	PWR_CUT_A_MSK			BIT(1)
-#define	PWR_CUT_B_MSK			BIT(2)
-#define	PWR_CUT_C_MSK			BIT(3)
-#define	PWR_CUT_D_MSK			BIT(4)
-#define	PWR_CUT_E_MSK			BIT(5)
-#define	PWR_CUT_F_MSK			BIT(6)
-#define	PWR_CUT_G_MSK			BIT(7)
-#define	PWR_CUT_ALL_MSK			0xFF
+/* The value of cmd: 4 bits */
+#define PWR_CMD_READ		0x00
+#define PWR_CMD_WRITE		0x01
+#define PWR_CMD_POLLING		0x02
+#define PWR_CMD_DELAY		0x03
+#define PWR_CMD_END		0x04
+
+/* The value of base: 4 bits */
+/*  define the base address of each block */
+#define PWR_BASEADDR_MAC	0x00
+#define PWR_BASEADDR_USB	0x01
+#define PWR_BASEADDR_PCIE	0x02
+#define PWR_BASEADDR_SDIO	0x03
+
+/* The value of interface_msk: 4 bits */
+#define PWR_INTF_SDIO_MSK	BIT(0)
+#define PWR_INTF_USB_MSK	BIT(1)
+#define PWR_INTF_PCI_MSK	BIT(2)
+#define PWR_INTF_ALL_MSK	(BIT(0)|BIT(1)|BIT(2)|BIT(3))
+
+/* The value of fab_msk: 4 bits */
+#define PWR_FAB_TSMC_MSK	BIT(0)
+#define PWR_FAB_UMC_MSK		BIT(1)
+#define PWR_FAB_ALL_MSK		(BIT(0)|BIT(1)|BIT(2)|BIT(3))
+
+/* The value of cut_msk: 8 bits */
+#define PWR_CUT_TESTCHIP_MSK	BIT(0)
+#define PWR_CUT_A_MSK		BIT(1)
+#define PWR_CUT_B_MSK		BIT(2)
+#define PWR_CUT_C_MSK		BIT(3)
+#define PWR_CUT_D_MSK		BIT(4)
+#define PWR_CUT_E_MSK		BIT(5)
+#define PWR_CUT_F_MSK		BIT(6)
+#define PWR_CUT_G_MSK		BIT(7)
+#define PWR_CUT_ALL_MSK		0xFF
 
 
 enum pwrseq_cmd_delat_unit {
@@ -120,8 +84,6 @@ struct wl_pwr_cfg {
 #define GET_PWR_CFG_MASK(__PWR_CMD)		__PWR_CMD.msk
 #define GET_PWR_CFG_VALUE(__PWR_CMD)		__PWR_CMD.value
 
-
-/*	Prototype of protected function. */
 u8 rtl88eu_pwrseqcmdparsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
 			    u8 ifacetype, struct wl_pwr_cfg pwrcfgCmd[]);
 
-- 
1.7.10.4

