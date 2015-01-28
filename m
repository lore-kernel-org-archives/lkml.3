Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280AbbA1EWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:22:24 -0500
Received: from mail.kernel.org ([198.145.29.136]:39895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217AbbA1EWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:16 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 089/177] staging:iio:ad5933: Drop "raw" from channel names
Date: Wed, 28 Jan 2015 12:09:05 +0800
Message-Id: <1422418236-12852-178-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 6822ee34ad57b29a3b44df2c2829910f03c34fa4 upstream.

"raw" is the name of a channel property, but should not be part of the
channel name itself.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/staging/iio/impedance-analyzer/ad5933.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
index 06b9fe2..2db80b1 100644
--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -124,7 +124,7 @@ static struct iio_chan_spec ad5933_channels[] = {
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "real_raw",
+		.extend_name = "real",
 		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
 		.address = AD5933_REG_REAL_DATA,
 		.scan_index = 0,
@@ -137,7 +137,7 @@ static struct iio_chan_spec ad5933_channels[] = {
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "imag_raw",
+		.extend_name = "imag",
 		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
 		.address = AD5933_REG_IMAG_DATA,
 		.scan_index = 1,
-- 
1.9.1

