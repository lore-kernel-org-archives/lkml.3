Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab3HZPQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:16:37 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38263 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3HZPL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:26 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/24] Staging: winbond: reg: white space deleted
Date: Mon, 26 Aug 2013 17:10:06 +0200
Message-Id: <1377529823-5116-8-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
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

