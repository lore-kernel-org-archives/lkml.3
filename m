Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaDXLeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:34:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaDXIw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/182] [media] v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support
Date: Thu, 24 Apr 2014 09:49:29 +0100
Message-Id: <1398329507-5911-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit bc826d6e39fe5f09cbadf8723e9183e6331b586f upstream.

The wrong ioctl numbers were used due to a copy-and-paste error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..b63a5e5 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -787,8 +787,8 @@ static int put_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct v4l2_subde
 #define VIDIOC_DQBUF32		_IOWR('V', 17, struct v4l2_buffer32)
 #define VIDIOC_ENUMSTD32	_IOWR('V', 25, struct v4l2_standard32)
 #define VIDIOC_ENUMINPUT32	_IOWR('V', 26, struct v4l2_input32)
-#define VIDIOC_SUBDEV_G_EDID32	_IOWR('V', 63, struct v4l2_subdev_edid32)
-#define VIDIOC_SUBDEV_S_EDID32	_IOWR('V', 64, struct v4l2_subdev_edid32)
+#define VIDIOC_SUBDEV_G_EDID32	_IOWR('V', 40, struct v4l2_subdev_edid32)
+#define VIDIOC_SUBDEV_S_EDID32	_IOWR('V', 41, struct v4l2_subdev_edid32)
 #define VIDIOC_TRY_FMT32      	_IOWR('V', 64, struct v4l2_format32)
 #define VIDIOC_G_EXT_CTRLS32    _IOWR('V', 71, struct v4l2_ext_controls32)
 #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
-- 
1.9.1

