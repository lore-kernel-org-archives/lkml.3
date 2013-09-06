Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab3IFITq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:19:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38374 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3IFITO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:19:14 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, dwmw2@infradead.org, lee.jones@linaro.org,
        sachin.kamat@linaro.org
Subject: [PATCH v3 4/4] pm2301-charger: Staticize pm2xxx_charger_die_therm_mngt
Date: Fri,  6 Sep 2013 13:31:12 +0530
Message-Id: <1378454473-24508-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378454473-24508-1-git-send-email-sachin.kamat@linaro.org>
References: <1378454473-24508-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm2xxx_charger_die_therm_mngt is used only in this file.
Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
No changes since v1.
---
 drivers/power/pm2301_charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 7214b66..b733c69 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -205,7 +205,7 @@ static int pm2xxx_charger_batt_therm_mngt(struct pm2xxx_charger *pm2, int val)
 }
 
 
-int pm2xxx_charger_die_therm_mngt(struct pm2xxx_charger *pm2, int val)
+static int pm2xxx_charger_die_therm_mngt(struct pm2xxx_charger *pm2, int val)
 {
 	queue_work(pm2->charger_wq, &pm2->check_main_thermal_prot_work);
 
-- 
1.7.9.5

