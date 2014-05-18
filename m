Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaERPcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:32:48 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49037 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaERPcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:32:47 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/28] staging: rtl8188eu: Remove unused funtion PHY_ScanOperationBackup8188E()
Date: Sun, 18 May 2014 21:02:18 +0530
Message-Id: <1400427138-19749-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index a7872c8..941ff74 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -754,14 +754,6 @@ PHY_SetTxPowerLevel8188E(
 	rtl8188e_PHY_RF6052SetOFDMTxPower(Adapter, &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0], channel);
 }

-void
-PHY_ScanOperationBackup8188E(
-		struct adapter *Adapter,
-		u8 Operation
-	)
-{
-}
-
 /*-----------------------------------------------------------------------------
  * Function:    PHY_SetBWModeCallback8192C()
  *
--
1.7.10.4

