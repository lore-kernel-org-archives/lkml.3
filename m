Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3HZPLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:19 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46019 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3HZPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:15 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/24] Staging: winbond: mto: deleted extern functions
Date: Mon, 26 Aug 2013 17:10:02 +0200
Message-Id: <1377529823-5116-4-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deleted declaration of external functions that weren't used on this driver.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/mto.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
index 22bb264..8d41eed 100644
--- a/drivers/staging/winbond/mto.h
+++ b/drivers/staging/winbond/mto.h
@@ -129,10 +129,6 @@ extern u16 MTO_Frag_Th_Tbl[];
 
 void MTO_Init(struct wbsoft_priv *);
 void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
-extern void MTO_PeriodicTimerExpired(struct wbsoft_priv *);
-extern void MTO_SetDTORateRange(struct wbsoft_priv *, u8 *, u8);
-extern u8 MTO_GetTxRate(struct wbsoft_priv *adapter, u32 fpdu_len);
-extern u8 MTO_GetTxFallbackRate(struct wbsoft_priv *adapter);
 
 #endif /* __MTO_H__ */
 
-- 
1.8.1.2

