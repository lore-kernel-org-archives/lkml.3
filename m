Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab3CZHJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:09:14 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:47957 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601Ab3CZHJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:09:12 -0400
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: linux@roeck-us.net, khali@linux-fr.org, lm-sensors@lm-sensors.org,
        cbou@mail.ru, dwmw2@infradead.org
Cc: linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, Hongbo Zhang <hongbo.zhang@linaro.org>
Subject: [PATCH v6 3/5] ab8500: power: add const attributes to some data arrays
Date: Tue, 26 Mar 2013 15:06:57 +0800
Message-Id: <1364281619-13208-4-git-send-email-hongbo.zhang@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1364281619-13208-1-git-send-email-hongbo.zhang@linaro.org>
References: <1364281619-13208-1-git-send-email-hongbo.zhang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds const attributes to AB8500 power and temperature related
read-only data arrays.

Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
---
 drivers/power/ab8500_bmdata.c | 18 +++++++++---------
 drivers/power/ab8500_fg.c     |  4 ++--
 include/linux/mfd/abx500.h    |  6 +++---
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index f836550..9c25ca8 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -11,7 +11,7 @@
  * Note that the res_to_temp table must be strictly sorted by falling resistance
  * values to work.
  */
-static struct abx500_res_to_temp temp_tbl_a_thermistor[] = {
+static const struct abx500_res_to_temp temp_tbl_a_thermistor[] = {
 	{-5, 53407},
 	{ 0, 48594},
 	{ 5, 43804},
@@ -29,7 +29,7 @@ static struct abx500_res_to_temp temp_tbl_a_thermistor[] = {
 	{65, 12500},
 };
 
-static struct abx500_res_to_temp temp_tbl_b_thermistor[] = {
+static const struct abx500_res_to_temp temp_tbl_b_thermistor[] = {
 	{-5, 200000},
 	{ 0, 159024},
 	{ 5, 151921},
@@ -47,7 +47,7 @@ static struct abx500_res_to_temp temp_tbl_b_thermistor[] = {
 	{65,  82869},
 };
 
-static struct abx500_v_to_cap cap_tbl_a_thermistor[] = {
+static const struct abx500_v_to_cap cap_tbl_a_thermistor[] = {
 	{4171,	100},
 	{4114,	 95},
 	{4009,	 83},
@@ -70,7 +70,7 @@ static struct abx500_v_to_cap cap_tbl_a_thermistor[] = {
 	{3247,	  0},
 };
 
-static struct abx500_v_to_cap cap_tbl_b_thermistor[] = {
+static const struct abx500_v_to_cap cap_tbl_b_thermistor[] = {
 	{4161,	100},
 	{4124,	 98},
 	{4044,	 90},
@@ -93,7 +93,7 @@ static struct abx500_v_to_cap cap_tbl_b_thermistor[] = {
 	{3250,	  0},
 };
 
-static struct abx500_v_to_cap cap_tbl[] = {
+static const struct abx500_v_to_cap cap_tbl[] = {
 	{4186,	100},
 	{4163,	 99},
 	{4114,	 95},
@@ -124,7 +124,7 @@ static struct abx500_v_to_cap cap_tbl[] = {
  * Note that the res_to_temp table must be strictly sorted by falling
  * resistance values to work.
  */
-static struct abx500_res_to_temp temp_tbl[] = {
+static const struct abx500_res_to_temp temp_tbl[] = {
 	{-5, 214834},
 	{ 0, 162943},
 	{ 5, 124820},
@@ -146,7 +146,7 @@ static struct abx500_res_to_temp temp_tbl[] = {
  * Note that the batres_vs_temp table must be strictly sorted by falling
  * temperature values to work.
  */
-static struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
+static const struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
 	{ 40, 120},
 	{ 30, 135},
 	{ 20, 165},
@@ -160,7 +160,7 @@ static struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
  * Note that the batres_vs_temp table must be strictly sorted by falling
  * temperature values to work.
  */
-static struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
+static const struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
 	{ 60, 300},
 	{ 30, 300},
 	{ 20, 300},
@@ -171,7 +171,7 @@ static struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
 };
 
 /* battery resistance table for LI ION 9100 battery */
-static struct batres_vs_temp temp_to_batres_tbl_9100[] = {
+static const struct batres_vs_temp temp_to_batres_tbl_9100[] = {
 	{ 60, 180},
 	{ 30, 180},
 	{ 20, 180},
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index b3bf178..d21456d 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -811,7 +811,7 @@ static int ab8500_fg_bat_voltage(struct ab8500_fg *di)
 static int ab8500_fg_volt_to_capacity(struct ab8500_fg *di, int voltage)
 {
 	int i, tbl_size;
-	struct abx500_v_to_cap *tbl;
+	const struct abx500_v_to_cap *tbl;
 	int cap = 0;
 
 	tbl = di->bat->bat_type[di->bat->batt_id].v_to_cap_tbl,
@@ -863,7 +863,7 @@ static int ab8500_fg_uncomp_volt_to_capacity(struct ab8500_fg *di)
 static int ab8500_fg_battery_resistance(struct ab8500_fg *di)
 {
 	int i, tbl_size;
-	struct batres_vs_temp *tbl;
+	const struct batres_vs_temp *tbl;
 	int resist = 0;
 
 	tbl = di->bat->bat_type[di->bat->batt_id].batres_tbl;
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 2138bd3..03fc0f1 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -173,11 +173,11 @@ struct abx500_battery_type {
 	int low_high_vol_lvl;
 	int battery_resistance;
 	int n_temp_tbl_elements;
-	struct abx500_res_to_temp *r_to_t_tbl;
+	const struct abx500_res_to_temp *r_to_t_tbl;
 	int n_v_cap_tbl_elements;
-	struct abx500_v_to_cap *v_to_cap_tbl;
+	const struct abx500_v_to_cap *v_to_cap_tbl;
 	int n_batres_tbl_elements;
-	struct batres_vs_temp *batres_tbl;
+	const struct batres_vs_temp *batres_tbl;
 };
 
 /**
-- 
1.8.0

