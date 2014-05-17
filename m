Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916AbaEQRrQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:47:16 -0400
Received: from v22013021537510585.yourvserver.net ([37.221.193.202]:39745 "EHLO
	finitebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964822AbaEQRrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:47:14 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2014 13:47:14 EDT
From: Marcus Farkas <marcus.farkas@finitebox.com>
To: gregkh@linuxfoundation.org
Cc: Marcus Farkas <marcus.farkas@finitebox.com>, linux-kernel@vger.kernel.org,
        larry.finger@lwfinger.net, florian.c.schilhabel@googlemail.com
Subject: [PATCH 3/3] staging: rtl8712: fix unnecessary line continuations
Date: Sat, 17 May 2014 19:38:31 +0200
Message-Id: <ce52364ea42e711f738c8c7c5e7e991794df008f.1400347661.git.marcus.farkas@finitebox.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
References: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
In-Reply-To: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
References: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following checkpatch warning:

rtl8712/rtl871x_security.c
    - 1178: WARNING: Avoid unnecessary line continuations

Signed-off-by: Marcus Farkas <marcus.farkas@finitebox.com>
---
 drivers/staging/rtl8712/rtl871x_security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index 1f2e197..0912f52 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -1178,7 +1178,7 @@ u32 r8712_aes_encrypt(struct _adapter *padapter, u8 *pxmitframe)
 			prwskeylen = 16;
 			for (curfragnum = 0; curfragnum < pattrib->nr_frags;
 			     curfragnum++) {
-				if ((curfragnum + 1) == pattrib->nr_frags) {\
+				if ((curfragnum + 1) == pattrib->nr_frags) {
 					length = pattrib->last_txcmdsz -
 						 pattrib->hdrlen -
 						 pattrib->iv_len -
-- 
1.9.2

