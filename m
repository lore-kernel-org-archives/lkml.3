Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaAFPU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:20:59 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:55940 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbaAFPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:20:57 -0500
From: Jesper Falk <jesperfalk94@gmail.com>
To: anton@enomsg.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Jesper Falk <jesperfalk94@gmail.com>
Subject: [PATCH] Power: abx500: Fixed coding style issues
Date: Mon,  6 Jan 2014 16:20:39 +0100
Message-Id: <1389021639-10326-1-git-send-email-jesperfalk94@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed else on new line and made tabs instead of spaces

Signed-off-by: Jesper Falk <jesperfalk94@gmail.com>
---
 drivers/power/abx500_chargalg.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 6d27236..a1ab145 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -227,7 +227,7 @@ enum maxim_ret {
  * @chg_info:		information about connected charger types
  * @batt_data:		data of the battery
  * @susp_status:	current charger suspension status
- * @bm:           	Platform specific battery management information
+ * @bm:			Platform specific battery management information
  * @curr_status:	Current step status for over-current protection
  * @parent:		pointer to the struct abx500
  * @chargalg_psy:	structure that holds the battery properties exposed by
@@ -362,13 +362,13 @@ static int abx500_chargalg_check_charger_enable(struct abx500_chargalg *di)
 
 	if (di->chg_info.charger_type & USB_CHG) {
 		return di->usb_chg->ops.check_enable(di->usb_chg,
-                         di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
-                         di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
+			di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
+			di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
 	} else if ((di->chg_info.charger_type & AC_CHG) &&
 		   !(di->ac_chg->external)) {
 		return di->ac_chg->ops.check_enable(di->ac_chg,
-                         di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
-                         di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
+			di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
+			di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
 	}
 	return 0;
 }
@@ -532,8 +532,7 @@ static int abx500_chargalg_kick_watchdog(struct abx500_chargalg *di)
 			di->usb_chg->ops.kick_wd(di->usb_chg);
 
 		return di->ac_chg->ops.kick_wd(di->ac_chg);
-	}
-	else if (di->usb_chg && di->usb_chg->ops.kick_wd &&
+	} else if (di->usb_chg && di->usb_chg->ops.kick_wd &&
 			di->chg_info.online_chg & USB_CHG)
 		return di->usb_chg->ops.kick_wd(di->usb_chg);
 
-- 
1.8.5.2

