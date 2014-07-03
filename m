Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbaGCJVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbaGCJVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 043/198] iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.
Date: Thu,  3 Jul 2014 10:18:06 +0100
Message-Id: <1404379241-8590-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jic23@kernel.org>

commit a91a73c8b39a6b8bcc53fafa5372c65387c81233 upstream.

Reported-by: Erik Habbinga <Erik.Habbinga@schneider-electric.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/adc/max1363.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
index f148d00b83f7..a7c2ddd1f7a2 100644
--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -1214,8 +1214,8 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
 		.info = &max1238_info,
-		.channels = max1238_channels,
-		.num_channels = ARRAY_SIZE(max1238_channels),
+		.channels = max1038_channels,
+		.num_channels = ARRAY_SIZE(max1038_channels),
 	},
 	[max11605] = {
 		.bits = 8,
@@ -1224,8 +1224,8 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
 		.info = &max1238_info,
-		.channels = max1238_channels,
-		.num_channels = ARRAY_SIZE(max1238_channels),
+		.channels = max1038_channels,
+		.num_channels = ARRAY_SIZE(max1038_channels),
 	},
 	[max11606] = {
 		.bits = 10,
@@ -1274,8 +1274,8 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
 		.info = &max1238_info,
-		.channels = max1238_channels,
-		.num_channels = ARRAY_SIZE(max1238_channels),
+		.channels = max1138_channels,
+		.num_channels = ARRAY_SIZE(max1138_channels),
 	},
 	[max11611] = {
 		.bits = 10,
@@ -1284,8 +1284,8 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
 		.info = &max1238_info,
-		.channels = max1238_channels,
-		.num_channels = ARRAY_SIZE(max1238_channels),
+		.channels = max1138_channels,
+		.num_channels = ARRAY_SIZE(max1138_channels),
 	},
 	[max11612] = {
 		.bits = 12,
-- 
1.9.1

