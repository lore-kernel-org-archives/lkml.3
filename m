Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaGaWgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:36:24 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37339 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaGaWgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:36:20 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH 6/8] staging: iio: accel: lis3l02dq_core.c: fix coding style
Date: Thu, 31 Jul 2014 19:34:56 -0300
Message-Id: <1406846098-19866-7-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
References: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing blank line after declarations.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/lis3l02dq_core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 898653c..f5e145c 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -212,6 +212,7 @@ static int lis3l02dq_write_thresh(struct iio_dev *indio_dev,
 				  int val, int val2)
 {
 	u16 value = val;
+
 	return lis3l02dq_spi_write_reg_s16(indio_dev,
 					   LIS3L02DQ_REG_THS_L_ADDR,
 					   value);
@@ -226,6 +227,7 @@ static int lis3l02dq_write_raw(struct iio_dev *indio_dev,
 	int ret = -EINVAL, reg;
 	u8 uval;
 	s8 sval;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		if (val > 255 || val < -256)
@@ -302,6 +304,7 @@ static ssize_t lis3l02dq_read_frequency(struct device *dev,
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	int ret, len = 0;
 	s8 t;
+
 	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_1_ADDR,
 				       (u8 *)&t);
@@ -565,6 +568,7 @@ static int lis3l02dq_read_event_config(struct iio_dev *indio_dev,
 	u8 val;
 	int ret;
 	u8 mask = (1 << (chan->channel2*2 + (dir == IIO_EV_DIR_RISING)));
+
 	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
 				       &val);
-- 
1.7.10.4

