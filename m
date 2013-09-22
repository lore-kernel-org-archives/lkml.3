Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3IVIU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:20:26 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59485 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IVIUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:20:22 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, zubair.lutfullah@gmail.com
Subject: [PATCH 2/3] iio: ti_am335x_adc: cleanup trigger related code
Date: Sun, 22 Sep 2013 13:20:04 +0500
Message-Id: <1379838005-15158-3-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trigger related headers and variables are not needed
as driver is now based on INDIO_BUFFER_HARDWARE mode

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 91dce1f..4eb63eb 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -30,9 +30,6 @@
 #include <linux/mfd/ti_am335x_tscadc.h>
 #include <linux/iio/buffer.h>
 #include <linux/iio/kfifo_buf.h>
-#include <linux/iio/trigger.h>
-#include <linux/iio/trigger_consumer.h>
-#include <linux/iio/triggered_buffer.h>
 
 struct tiadc_device {
 	struct ti_tscadc_dev *mfd_tscadc;
@@ -40,7 +37,6 @@ struct tiadc_device {
 	u8 channel_line[8];
 	u8 channel_step[8];
 	int buffer_en_ch_steps;
-	struct iio_trigger *trig;
 	u16 data[8];
 };
 
-- 
1.7.9.5

