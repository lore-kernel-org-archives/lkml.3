Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaLUMnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:43:11 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45153 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaLUMnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:43:08 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: lars@metafoo.de
Cc: Michael.Hennerich@analog.com, jic23@kernel.org, knaack.h@gmx.de,
        pmeerw@pmeerw.net, gregkh@linuxfoundation.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Subject: [PATCH] staging : iio: meter: ade7759: fix space before , coding style issue
Date: Sun, 21 Dec 2014 18:12:49 +0530
Message-Id: <1419165769-29782-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves the space before , coding style issue found by
checkpatch in ade7759.c

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
---
 drivers/staging/iio/meter/ade7759.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/meter/ade7759.c b/drivers/staging/iio/meter/ade7759.c
index 7d21743..b0c7dbc 100644
--- a/drivers/staging/iio/meter/ade7759.c
+++ b/drivers/staging/iio/meter/ade7759.c
@@ -116,7 +116,7 @@ static int ade7759_spi_read_reg_40(struct device *dev,
 
 	mutex_lock(&st->buf_lock);
 	st->tx[0] = ADE7759_READ_REG(reg_address);
-	memset(&st->tx[1], 0 , 5);
+	memset(&st->tx[1], 0, 5);
 
 	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
 	if (ret) {
-- 
1.7.9.5

