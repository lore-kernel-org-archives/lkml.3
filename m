Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaLTQAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:00:18 -0500
Received: from mail-pa0-f65.google.com ([209.85.220.65]:60424 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaLTQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:00:15 -0500
From: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, jmmahler@gmail.com
Cc: Larry.Finger@lwfinger.net, navin.patidar@gmail.com,
        ebru.akagunduz@gmail.com, paulmck@linux.vnet.ibm.com,
        heenasirwani@gmail.com, cengelma@gmx.at, standby24x7@gmail.com,
        linux-kernel@vger.kernel.org,
        Gangadhar Vukkesala <gangs.freelancer@gmail.com>
Subject: [PATCH v4] staging: rtl8188eu: Fixed a space coding style issue.
Date: Sat, 20 Dec 2014 21:29:47 +0530
Message-Id: <1419091187-2775-1-git-send-email-gangs.freelancer@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a space coding style issue which was found when running checkpatch.pl
script on rtw_ap.c.

Signed-off-by: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index d61842e..da19145 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -509,7 +509,7 @@ void add_RATid(struct adapter *padapter, struct sta_info *psta, u8 rssi_level)
 		tx_ra_bitmap |= ((raid<<28)&0xf0000000);
 
 		DBG_88E("%s => mac_id:%d , raid:%d , bitmap = 0x%x, arg = 0x%x\n",
-			__func__ , psta->mac_id, raid , tx_ra_bitmap, arg);
+			__func__, psta->mac_id, raid, tx_ra_bitmap, arg);
 
 		/* bitmap[0:27] = tx_rate_bitmap */
 		/* bitmap[28:31]= Rate Adaptive id */
-- 
Gangadhar V

