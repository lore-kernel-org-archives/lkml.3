Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbaFKR0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:26:55 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62256 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896AbaFKR0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:26:53 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com, anarey@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 2/2] Staging: rtl8192u: r8192U_core.c Converted a C99 comment to fix code-style error
Date: Wed, 11 Jun 2014 10:26:44 -0700
Message-Id: <1402507604-15710-2-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402507604-15710-1-git-send-email-c@24.io>
References: <1402507604-15710-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted a C99 comment to fix the following error:

ERROR: trailing statements should be on next line

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 512bf5c..67c5918 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1115,7 +1115,7 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 		tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
 		tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-		if (tcb_desc->bAMPDUEnable) {//AMPDU enabled
+		if (tcb_desc->bAMPDUEnable) { /* AMPDU enabled */
 			tx_fwinfo->AllowAggregation = 1;
 			/* DWORD 1 */
 			tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
-- 
1.9.1

