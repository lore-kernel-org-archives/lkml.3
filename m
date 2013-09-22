Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3IVIUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:20:22 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45691 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3IVIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:20:19 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, zubair.lutfullah@gmail.com
Subject: [PATCH 1/3] iio: ti_am335x_adc: fix static in function header
Date: Sun, 22 Sep 2013 13:20:03 +0500
Message-Id: <1379838005-15158-2-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static is missing in function header. Corrected.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 5287bff..91dce1f 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -226,7 +226,7 @@ static const struct iio_buffer_setup_ops tiadc_buffer_setup_ops = {
 	.postdisable = &tiadc_buffer_postdisable,
 };
 
-int tiadc_iio_buffered_hardware_setup(struct iio_dev *indio_dev,
+static int tiadc_iio_buffered_hardware_setup(struct iio_dev *indio_dev,
 	irqreturn_t (*pollfunc_bh)(int irq, void *p),
 	irqreturn_t (*pollfunc_th)(int irq, void *p),
 	int irq,
-- 
1.7.9.5

