Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbaGVWfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:35:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366AbaGVW0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Cameron <jic23@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 028/116] iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.
Date: Tue, 22 Jul 2014 15:20:39 -0700
Message-Id: <1406067727-19683-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jic23@kernel.org>

commit a91a73c8b39a6b8bcc53fafa5372c65387c81233 upstream.

Reported-by: Erik Habbinga <Erik.Habbinga@schneider-electric.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/adc/max1363.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
index 03b25b3..96670f9 100644
--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -1211,8 +1211,8 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
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
@@ -1221,8 +1221,8 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
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
@@ -1271,8 +1271,8 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
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
@@ -1281,8 +1281,8 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
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

