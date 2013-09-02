Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3IBL2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:28:21 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40134 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab3IBL2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:28:18 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, sachin.kamat@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/4] pm2301-charger: Staticize pm2xxx_charger_die_therm_mngt
Date: Mon,  2 Sep 2013 16:40:25 +0530
Message-Id: <1378120226-24805-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
References: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm2xxx_charger_die_therm_mngt is used only in this file.
Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/pm2301_charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ab87d1a..b9e1ef7 100644
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

