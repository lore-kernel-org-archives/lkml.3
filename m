Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3AYHBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:01:47 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:62525 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3AYHBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:01:44 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 1/2] media: add support for decoder subdevs along with sensor and others
Date: Fri, 25 Jan 2013 12:31:07 +0530
Message-Id: <1359097268-22779-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359097268-22779-1-git-send-email-prabhakar.lad@ti.com>
References: <1359097268-22779-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

A lot of SOCs including Texas Instruments Davinci family mainly use
video decoders as input devices. Here the initial subdevice node
from where the input really comes is this decoder, for which support
is needed as part of the Media Controller infrastructure. This patch
adds an additional flag to include the decoders along with others,
such as the sensor and lens.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 include/uapi/linux/media.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 0ef8833..fa44ed9 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -56,6 +56,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
 #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
 #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
+#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
 
 #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
 
-- 
1.7.4.1

