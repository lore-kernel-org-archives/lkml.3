Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965168AbaFXP4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:56:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965051AbaFXP4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Erik Habbinga <Erik.Habbinga@schneider-electric.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>
Subject: [PATCH 3.15 41/61] iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.
Date: Tue, 24 Jun 2014 11:51:24 -0400
Message-Id: <20140624154954.657060600@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jic23@kernel.org>

commit a91a73c8b39a6b8bcc53fafa5372c65387c81233 upstream.

Reported-by: Erik Habbinga <Erik.Habbinga@schneider-electric.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/max1363.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -1252,8 +1252,8 @@ static const struct max1363_chip_info ma
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
@@ -1262,8 +1262,8 @@ static const struct max1363_chip_info ma
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
@@ -1312,8 +1312,8 @@ static const struct max1363_chip_info ma
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
@@ -1322,8 +1322,8 @@ static const struct max1363_chip_info ma
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


