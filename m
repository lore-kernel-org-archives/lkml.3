Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3JNCmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 22:42:06 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58597 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab3JNCmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 22:42:04 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Cc: badarkhe.manish@gmail.com, a.zummo@towertech.it
Subject: [PATCH] rtc: rtc-tps65910: remove unnecessary include
Date: Mon, 14 Oct 2013 08:11:56 +0530
Message-Id: <1381718516-3698-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, driver includes 'pm_runtime.h' which is not
used anywhere in code hence remove this unnecessory
inclusion.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 a9caf04... 7af0020... M	drivers/rtc/rtc-tps65910.c
 drivers/rtc/rtc-tps65910.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index a9caf04..7af0020 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -22,7 +22,6 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
-#include <linux/pm_runtime.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/tps65910.h>
 
-- 
1.7.10.4

