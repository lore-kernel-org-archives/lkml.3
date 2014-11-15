Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaKOTri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 14:47:38 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50883 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbaKOTrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 14:47:36 -0500
Date: Sat, 15 Nov 2014 20:43:37 +0100
From: Christian Resell <christian.resell@gmail.com>
To: m.chehab@samsung.com
Cc: gregkh@linuxfoundation.org, hans.verkuil@cisco.com, pali.rohar@gmail.com,
        pavel@ucw.cz, fengguang.wu@intel.com, yongjun_wei@trendmicro.com.cn,
        askb23@gmail.com, luke.hart@birchleys.eu, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: bcm2048: fix coding style error
Message-ID: <20141115194337.GF15904@Kosekroken.jensen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple style fix (checkpatch.pl: "space prohibited before that ','").
For the eudyptula challenge (http://eudyptula-challenge.org/).

Signed-off-by: Christian F. Resell <christian.resell@gmail.com>
---
diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 2bba370..bdc6854 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2707,7 +2707,7 @@ static int __exit bcm2048_i2c_driver_remove(struct i2c_client *client)
  *	bcm2048_i2c_driver - i2c driver interface
  */
 static const struct i2c_device_id bcm2048_id[] = {
-	{ "bcm2048" , 0 },
+	{ "bcm2048", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(i2c, bcm2048_id);
