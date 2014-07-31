Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaGaWgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:36:12 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:63326 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaGaWgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:36:09 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH 3/8] staging: iio: accel: adis16204_core.c: fix coding style
Date: Thu, 31 Jul 2014 19:34:53 -0300
Message-Id: <1406846098-19866-4-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
References: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing blank line after declaration.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/adis16204_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/accel/adis16204_core.c b/drivers/staging/iio/accel/adis16204_core.c
index 19eaebc..4c8acbc 100644
--- a/drivers/staging/iio/accel/adis16204_core.c
+++ b/drivers/staging/iio/accel/adis16204_core.c
@@ -119,6 +119,7 @@ static int adis16204_write_raw(struct iio_dev *indio_dev,
 	int bits;
 	s16 val16;
 	u8 addr;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		switch (chan->type) {
-- 
1.7.10.4

