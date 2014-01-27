Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaA0RrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:47:00 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:42585 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaA0Rq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:46:57 -0500
From: Luis Ortega <luiorpe1@upv.es>
To: dmitry.torokhov@gmail.com
Cc: heiko@sntech.de, yongjun_wei@trendmicro.com.cn,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Ortega <luiorpe1@upv.es>
Subject: [PATCH 1/4] Input: zforce - fix spelling errors
Date: Mon, 27 Jan 2014 19:46:10 +0100
Message-Id: <1390848373-7723-2-git-send-email-luiorpe1@upv.es>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
References: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a few spelling errors.

Signed-off-by: Luis Ortega <luiorpe1@upv.es>
---
 drivers/input/touchscreen/zforce_ts.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/zforce_ts.c b/drivers/input/touchscreen/zforce_ts.c
index 2175f34..c145c1d 100644
--- a/drivers/input/touchscreen/zforce_ts.c
+++ b/drivers/input/touchscreen/zforce_ts.c
@@ -64,7 +64,7 @@
 #define RESPONSE_STATUS		0X1e
 
 /*
- * Notifications are send by the touch controller without
+ * Notifications are sent by the touch controller without
  * being requested by the driver and include for example
  * touch indications
  */
@@ -103,8 +103,8 @@ struct zforce_point {
  * @suspended		device suspended
  * @access_mutex	serialize i2c-access, to keep multipart reads together
  * @command_done	completion to wait for the command result
- * @command_mutex	serialize commands send to the ic
- * @command_waiting	the id of the command that that is currently waiting
+ * @command_mutex	serialize commands sent to the ic
+ * @command_waiting	the id of the command that is currently waiting
  *			for a result
  * @command_result	returned result of the command
  */
@@ -332,7 +332,7 @@ static int zforce_touch_event(struct zforce_ts *ts, u8 *payload)
 
 	count = payload[0];
 	if (count > ZFORCE_REPORT_POINTS) {
-		dev_warn(&client->dev, "to many coordinates %d, expected max %d\n",
+		dev_warn(&client->dev, "too many coordinates %d, expected max %d\n",
 			 count, ZFORCE_REPORT_POINTS);
 		count = ZFORCE_REPORT_POINTS;
 	}
@@ -798,7 +798,7 @@ static int zforce_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	/* this gets the firmware version among other informations */
+	/* this gets the firmware version among other information */
 	ret = zforce_command_wait(ts, COMMAND_STATUS);
 	if (ret < 0) {
 		dev_err(&client->dev, "couldn't get status, %d\n", ret);
-- 
1.8.5.3

