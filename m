Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaGaWgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:36:36 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:43637 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaGaWg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:36:27 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH 8/8] staging: iio: accel: sca3000_core.c: fix coding style
Date: Thu, 31 Jul 2014 19:34:58 -0300
Message-Id: <1406846098-19866-9-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
References: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing blank line after declaration and keep line in
80-chars limit.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/sca3000_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index ed30e32..1ff299f 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -506,7 +506,8 @@ static int sca3000_read_raw(struct iio_dev *indio_dev,
 				mutex_unlock(&st->lock);
 				return ret;
 			}
-			*val = ((st->rx[0] & 0x3F) << 3) | ((st->rx[1] & 0xE0) >> 5);
+			*val = ((st->rx[0] & 0x3F) << 3)
+				| ((st->rx[1] & 0xE0) >> 5);
 		}
 		mutex_unlock(&st->lock);
 		return IIO_VAL_INT;
@@ -713,6 +714,7 @@ static int sca3000_read_thresh(struct iio_dev *indio_dev,
 	int ret, i;
 	struct sca3000_state *st = iio_priv(indio_dev);
 	int num = chan->channel2;
+
 	mutex_lock(&st->lock);
 	ret = sca3000_read_ctrl_reg(st, sca3000_addresses[num][1]);
 	mutex_unlock(&st->lock);
-- 
1.7.10.4

