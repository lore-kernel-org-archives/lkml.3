Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaKROmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:42:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbaKROKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 139/206] staging:iio:ad5933: Drop "raw" from channel names
Date: Tue, 18 Nov 2014 15:08:14 +0100
Message-Id: <0a63bb30eee369a03a72c3676b85d457505d5cdd.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6822ee34ad57b29a3b44df2c2829910f03c34fa4 upstream.

"raw" is the name of a channel property, but should not be part of the
channel name itself.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/iio/impedance-analyzer/ad5933.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
index 9d5f205807c5..bc23d66a7a1e 100644
--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -125,7 +125,7 @@ static const struct iio_chan_spec ad5933_channels[] = {
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "real_raw",
+		.extend_name = "real",
 		.address = AD5933_REG_REAL_DATA,
 		.scan_index = 0,
 		.scan_type = {
@@ -137,7 +137,7 @@ static const struct iio_chan_spec ad5933_channels[] = {
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "imag_raw",
+		.extend_name = "imag",
 		.address = AD5933_REG_IMAG_DATA,
 		.scan_index = 1,
 		.scan_type = {
-- 
2.1.3

