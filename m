Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaHEBsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:48:15 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:43453 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaHEBsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:48:12 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH v2 4/8] staging: iio: accel: adis16209_core.c: Add blank line between declarations and code
Date: Mon,  4 Aug 2014 22:46:59 -0300
Message-Id: <1407203223-9700-5-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1.204.gae8bc8d
In-Reply-To: <1407203223-9700-1-git-send-email-mopsfelder@gmail.com>
References: <1407203223-9700-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing blank line between declarations and code,
satisfying checkpatch.pl.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/adis16209_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/accel/adis16209_core.c b/drivers/staging/iio/accel/adis16209_core.c
index 374dc6e..b2c7aed 100644
--- a/drivers/staging/iio/accel/adis16209_core.c
+++ b/drivers/staging/iio/accel/adis16209_core.c
@@ -44,6 +44,7 @@ static int adis16209_write_raw(struct iio_dev *indio_dev,
 	int bits;
 	s16 val16;
 	u8 addr;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		switch (chan->type) {
-- 
2.1.0.rc1.204.gae8bc8d

