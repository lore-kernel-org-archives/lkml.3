Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567Ab3DCMT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:19:58 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61057 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab3DCMTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:19:55 -0400
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: linux@roeck-us.net, khali@linux-fr.org, lm-sensors@lm-sensors.org,
        cbou@mail.ru, dwmw2@infradead.org
Cc: linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        linux-kernel@vger.kernel.org, Hongbo Zhang <hongbo.zhang@linaro.org>
Subject: [PATCH v8 2/5] ab8500: power: eliminate CamelCase warning of some variables
Date: Wed,  3 Apr 2013 20:18:09 +0800
Message-Id: <1364991492-2421-3-git-send-email-hongbo.zhang@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1364991492-2421-1-git-send-email-hongbo.zhang@linaro.org>
References: <1364991492-2421-1-git-send-email-hongbo.zhang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some AB8500 power related variable names don't comply with kernel coding rules,
any new patch using these variables will result in CamelCase warnings from
checkpatch.pl, this patch re-name these variables.

Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
---
 drivers/power/ab8500_bmdata.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index 85742a6..05ad966 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -11,7 +11,7 @@
  * Note that the res_to_temp table must be strictly sorted by falling resistance
  * values to work.
  */
-static struct abx500_res_to_temp temp_tbl_A_thermistor[] = {
+static struct abx500_res_to_temp temp_tbl_a_thermistor[] = {
 	{-5, 53407},
 	{ 0, 48594},
 	{ 5, 43804},
@@ -29,7 +29,7 @@ static struct abx500_res_to_temp temp_tbl_A_thermistor[] = {
 	{65, 12500},
 };
 
-static struct abx500_res_to_temp temp_tbl_B_thermistor[] = {
+static struct abx500_res_to_temp temp_tbl_b_thermistor[] = {
 	{-5, 200000},
 	{ 0, 159024},
 	{ 5, 151921},
@@ -47,7 +47,7 @@ static struct abx500_res_to_temp temp_tbl_B_thermistor[] = {
 	{65,  82869},
 };
 
-static struct abx500_v_to_cap cap_tbl_A_thermistor[] = {
+static struct abx500_v_to_cap cap_tbl_a_thermistor[] = {
 	{4171,	100},
 	{4114,	 95},
 	{4009,	 83},
@@ -70,7 +70,7 @@ static struct abx500_v_to_cap cap_tbl_A_thermistor[] = {
 	{3247,	  0},
 };
 
-static struct abx500_v_to_cap cap_tbl_B_thermistor[] = {
+static struct abx500_v_to_cap cap_tbl_b_thermistor[] = {
 	{4161,	100},
 	{4124,	 98},
 	{4044,	 90},
@@ -230,10 +230,10 @@ static struct abx500_battery_type bat_type_thermistor[] = {
 		.maint_b_chg_timer_h = 200,
 		.low_high_cur_lvl = 300,
 		.low_high_vol_lvl = 4000,
-		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_A_thermistor),
-		.r_to_t_tbl = temp_tbl_A_thermistor,
-		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_A_thermistor),
-		.v_to_cap_tbl = cap_tbl_A_thermistor,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_a_thermistor),
+		.r_to_t_tbl = temp_tbl_a_thermistor,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_a_thermistor),
+		.v_to_cap_tbl = cap_tbl_a_thermistor,
 		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
 		.batres_tbl = temp_to_batres_tbl_thermistor,
 
@@ -258,10 +258,10 @@ static struct abx500_battery_type bat_type_thermistor[] = {
 		.maint_b_chg_timer_h = 200,
 		.low_high_cur_lvl = 300,
 		.low_high_vol_lvl = 4000,
-		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_B_thermistor),
-		.r_to_t_tbl = temp_tbl_B_thermistor,
-		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_B_thermistor),
-		.v_to_cap_tbl = cap_tbl_B_thermistor,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_b_thermistor),
+		.r_to_t_tbl = temp_tbl_b_thermistor,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_b_thermistor),
+		.v_to_cap_tbl = cap_tbl_b_thermistor,
 		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
 		.batres_tbl = temp_to_batres_tbl_thermistor,
 	},
-- 
1.8.0

