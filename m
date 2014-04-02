Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbaDBJf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:35:29 -0400
Received: from mailrelay.sea-ab.se ([91.223.232.53]:35152 "EHLO
	mailrelay.sea-ab.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbaDBJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:35:27 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2014 05:35:27 EDT
Date: Wed, 2 Apr 2014 11:25:19 +0200
From: Martin Berglund <martin@rogsta.net>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, arnaud.patard@rtp-net.org, martin@rogsta.net
Subject: [PATCH] Staging: xgifb: Coding style cleanup, newline added after
 declarations
Message-ID: <20140402092519.GA7942@martin-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added newlines after declarations.

Signed-off-by: Martin Berglund <martin@rogsta.net>
---
 drivers/staging/xgifb/XGI_main_26.c | 2 ++
 drivers/staging/xgifb/vb_init.c     | 2 ++
 drivers/staging/xgifb/vb_setmode.c  | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 46680468..a62d4dd 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -66,6 +66,7 @@ static int XGIfb_mode_rate_to_dclock(struct vb_device_info *XGI_Pr,
 	unsigned short ModeIdIndex = 0, ClockIndex = 0;
 	unsigned short RefreshRateTableIndex = 0;
 	int Clock;
+
 	InitTo330Pointer(HwDeviceExtension->jChipType, XGI_Pr);
 
 	XGI_SearchModeID(ModeNo, &ModeIdIndex);
@@ -95,6 +96,7 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 	unsigned short HRE, HBE, HRS, HDE;
 	unsigned char sr_data, cr_data, cr_data2;
 	int B, C, D, F, temp, j;
+
 	InitTo330Pointer(HwDeviceExtension->jChipType, XGI_Pr);
 	if (!XGI_SearchModeID(ModeNo, &ModeIdIndex))
 		return 0;
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 2154172..ff210dd 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -130,6 +130,7 @@ static void XGINew_DDRII_Bootup_XG27(
 			unsigned long P3c4, struct vb_device_info *pVBInfo)
 {
 	unsigned long P3d4 = P3c4 + 0x10;
+
 	pVBInfo->ram_type = XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
 	XGINew_SetMemoryClock(pVBInfo);
 
@@ -389,6 +390,7 @@ static void XGI_SetDRAM_Helper(unsigned long P3d4, u8 seed, u8 temp2, u8 reg,
 	u8 shift_factor, u8 mask1, u8 mask2)
 {
 	u8 j;
+
 	for (j = 0; j < 4; j++) {
 		temp2 |= (((seed >> (2 * j)) & 0x03) << shift_factor);
 		xgifb_reg_set(P3d4, reg, temp2);
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 400c726..c638c8f 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -49,6 +49,7 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 
 	if (ChipType == XG27) {
 		unsigned char temp;
+
 		pVBInfo->MCLKData = XGI27New_MCLKData;
 		pVBInfo->CR40 = XGI27_cr41;
 		pVBInfo->XGINew_CR97 = 0xc1;
@@ -5222,6 +5223,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	unsigned short temp;
 
 	int i;
+
 	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
 
 	/* to fix XG42 single LCD sense to CRT+LCD */
-- 
1.8.4.5

