Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaBJPbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:31:39 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50458 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaBJPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:31:35 -0500
From: Laszlo Papp <lpapp@kde.org>
To: jdelvare@suse.de, linux@roeck-us.net
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] hwmon: (max6650) Rename the device ids to contain the hwmon suffix
Date: Mon, 10 Feb 2014 15:25:53 +0000
Message-Id: <1392045953-26596-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the preparation of creating an mfd driver and then refactor this one into a
platform driver in order to add some pinctrl functionality to the chip, it is
necessary to start the series with this change so that the mfd driver can refer
to the proper name in the subsequent change without making changes in more than
one driver later.

This was a request from Lee Jones, the MFD subsystem maintainer.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/hwmon/max6650.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 0cafc39..3c36edc 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -116,8 +116,8 @@ static struct max6650_data *max6650_update_device(struct device *dev);
  */
 
 static const struct i2c_device_id max6650_id[] = {
-	{ "max6650", 1 },
-	{ "max6651", 4 },
+	{ "max6650-hwmon", 1 },
+	{ "max6651-hwmon", 4 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max6650_id);
-- 
1.8.5.3

