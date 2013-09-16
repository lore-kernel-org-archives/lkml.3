Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3IPNtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:49:22 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:38393 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab3IPNoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:44:10 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/24] Staging: winbond: reg: white space deleted
Date: Mon, 16 Sep 2013 15:43:27 +0200
Message-Id: <1379339024-12157-8-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

White space deleted before semicolons.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 5883d23..80b4b34 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1088,7 +1088,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		msleep(5);
 
 		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x0F << 20) | 0xF01A0, 20);
-		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp) ;
+		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 
 		Wb35Reg_WriteSync(pHwData, 0x105c, pHwData->reg.BB5C);
 		pHwData->reg.BB50 &= ~0x13; /* (MASK_IQCAL_MODE|MASK_CALIB_START); */
@@ -2096,7 +2096,7 @@ void Mxx_initial(struct hw_data *pHwData)
 	pltmp[5] = reg->M38_MacControl;
 
 	/* M3C */
-	tmp = (DEFAULT_PIFST << 26) | (DEFAULT_EIFST << 16) | (DEFAULT_DIFST << 8) | (DEFAULT_SIFST << 4) | DEFAULT_OSIFST ;
+	tmp = (DEFAULT_PIFST << 26) | (DEFAULT_EIFST << 16) | (DEFAULT_DIFST << 8) | (DEFAULT_SIFST << 4) | DEFAULT_OSIFST;
 	reg->M3C_MacControl = tmp;
 	pltmp[6] = tmp;
 
-- 
1.8.1.2

