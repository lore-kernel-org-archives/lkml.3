Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaBEP4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:56:43 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:54228 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaBEP4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:56:42 -0500
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, <prabhakar.csengg@gmail.com>,
        Martin Bugge <martin.bugge@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH] media: i2c: Kconfig: create dependency to MEDIA_CONTROLLER for adv7*
Date: Wed,  5 Feb 2014 16:56:13 +0100
Message-Id: <1391615773-26467-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These chips makes use of the media_entity in the v4l2_subdev struct
and is therefor dependent of the  MEDIA_CONTROLLER config.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/media/i2c/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index d18be19..1771b77 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -196,7 +196,7 @@ config VIDEO_ADV7183
 
 config VIDEO_ADV7604
 	tristate "Analog Devices ADV7604 decoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
 	---help---
 	  Support for the Analog Devices ADV7604 video decoder.
 
@@ -208,7 +208,7 @@ config VIDEO_ADV7604
 
 config VIDEO_ADV7842
 	tristate "Analog Devices ADV7842 decoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
 	---help---
 	  Support for the Analog Devices ADV7842 video decoder.
 
@@ -431,7 +431,7 @@ config VIDEO_ADV7393
 
 config VIDEO_ADV7511
 	tristate "Analog Devices ADV7511 encoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
 	---help---
 	  Support for the Analog Devices ADV7511 video encoder.
 
-- 
1.7.10.4

