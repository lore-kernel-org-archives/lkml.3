Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaAFQzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:55:19 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:53390 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaAFQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:55:17 -0500
From: Jesper Falk <jesperfalk94@gmail.com>
To: anton@enomsg.org
Cc: dwmw2@infradead.org, markus@trippelsdorf.de, akpm@linux-foundation.org,
        kyungsik.lee@lge.com, linux-kernel@vger.kernel.org,
        Jesper Falk <jesperfalk94@gmail.com>
Subject: [PATCH] Power: da9030 and da9059 Fixed coding style
Date: Mon,  6 Jan 2014 17:54:57 +0100
Message-Id: <1389027297-14419-1-git-send-email-jesperfalk94@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style in da9030_battery and da9052-battery

Signed-off-by: Jesper Falk <jesperfalk94@gmail.com>
---
 .gitignore                     | 2 +-
 drivers/power/da9030_battery.c | 2 +-
 drivers/power/da9052-battery.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index 7e9932e..681849a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -44,7 +44,7 @@ modules.builtin
 /vmlinuz
 /System.map
 /Module.markers
-/Module.symvers
+*/Module.symvers
 
 #
 # Debian directory (make deb-pkg)
diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index ae6c418..82316ad 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -2,7 +2,7 @@
  * Battery charger driver for Dialog Semiconductor DA9030
  *
  * Copyright (C) 2008 Compulab, Ltd.
- * 	Mike Rapoport <mike@compulab.co.il>
+ *	Mike Rapoport <mike@compulab.co.il>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index f8f4c0f..9972085 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -484,7 +484,7 @@ static int da9052_USB_current_notifier(struct notifier_block *nb,
 	    *current_mA > da9052_chg_current_lim[row][DA9052_CHG_LIM_COLS - 1])
 		return -EINVAL;
 
-	for (col = 0; col <= DA9052_CHG_LIM_COLS - 1 ; col++) {
+	for (col = 0; col <= DA9052_CHG_LIM_COLS - 1; col++) {
 		if (*current_mA <= da9052_chg_current_lim[row][col])
 			break;
 	}
-- 
1.8.5.2

