Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbaHFRGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:06:33 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38913 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaHFRGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:06:31 -0400
From: Oussama Jabbari <oussama.jabbari@gmail.com>
To: jic23@kernel.org
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org, lars@metafoo.de,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: adis16060: Fix coding style problem
Date: Wed,  6 Aug 2014 19:06:16 +0200
Message-Id: <1407344776-2838-1-git-send-email-oussama.jabbari@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a warning from checkpatch.pl script :
"WARNING: Missing a blank line after declarations"

Signed-off-by: Oussama Jabbari <oussama.jabbari@gmail.com>
---
The reason of this patch is for completing one task
of the Eudyptula Challenge.

 drivers/staging/iio/gyro/adis16060_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/gyro/adis16060_core.c b/drivers/staging/iio/gyro/adis16060_core.c
index d5d395c..4c5869d 100644
--- a/drivers/staging/iio/gyro/adis16060_core.c
+++ b/drivers/staging/iio/gyro/adis16060_core.c
@@ -180,6 +180,7 @@ static int adis16060_w_probe(struct spi_device *spi)
 	int ret;
 	struct iio_dev *indio_dev = adis16060_iio_dev;
 	struct adis16060_state *st;
+
 	if (!indio_dev) {
 		ret =  -ENODEV;
 		goto error_ret;
-- 
1.7.9.5

