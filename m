Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966514AbaKLBx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:53:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966493AbaKLBxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:53:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.10 077/123] staging:iio:ad5933: Drop "raw" from channel names
Date: Wed, 12 Nov 2014 10:17:23 +0900
Message-Id: <20141112011722.502050369@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 6822ee34ad57b29a3b44df2c2829910f03c34fa4 upstream.

"raw" is the name of a channel property, but should not be part of the
channel name itself.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/impedance-analyzer/ad5933.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -125,7 +125,7 @@ static const struct iio_chan_spec ad5933
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "real_raw",
+		.extend_name = "real",
 		.address = AD5933_REG_REAL_DATA,
 		.scan_index = 0,
 		.scan_type = {
@@ -137,7 +137,7 @@ static const struct iio_chan_spec ad5933
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "imag_raw",
+		.extend_name = "imag",
 		.address = AD5933_REG_IMAG_DATA,
 		.scan_index = 1,
 		.scan_type = {


