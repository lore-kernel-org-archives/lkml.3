Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaHEBsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:48:06 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:39548 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaHEBsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:48:03 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH v2 1/8] staging: iio: accel: adis16203_core.c: Add blank lines between declarations and code
Date: Mon,  4 Aug 2014 22:46:56 -0300
Message-Id: <1407203223-9700-2-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1.204.gae8bc8d
In-Reply-To: <1407203223-9700-1-git-send-email-mopsfelder@gmail.com>
References: <1407203223-9700-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing blank lines between declarations and code,
satisfying checkpatch.pl.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/adis16203_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/iio/accel/adis16203_core.c b/drivers/staging/iio/accel/adis16203_core.c
index f472137..fbbe93f 100644
--- a/drivers/staging/iio/accel/adis16203_core.c
+++ b/drivers/staging/iio/accel/adis16203_core.c
@@ -37,6 +37,7 @@ static int adis16203_write_raw(struct iio_dev *indio_dev,
 	struct adis *st = iio_priv(indio_dev);
 	/* currently only one writable parameter which keeps this simple */
 	u8 addr = adis16203_addresses[chan->scan_index];
+
 	return adis_write_reg_16(st, addr, val & 0x3FFF);
 }
 
@@ -50,6 +51,7 @@ static int adis16203_read_raw(struct iio_dev *indio_dev,
 	int bits;
 	u8 addr;
 	s16 val16;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		return adis_single_conversion(indio_dev, chan,
-- 
2.1.0.rc1.204.gae8bc8d

