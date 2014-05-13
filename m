Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaEMJg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:36:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60937 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760119AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/182] media: v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support
Date: Tue, 13 May 2014 11:27:22 +0200
Message-Id: <957bbbc7789c31faadae48f64e83f43794fd0180.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bc826d6e39fe5f09cbadf8723e9183e6331b586f upstream.

The wrong ioctl numbers were used due to a copy-and-paste error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a454a4c..b63a5e584aa0 100644
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
1.9.3

