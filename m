Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbaEDP5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:57:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbaEDPmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 64/86] media: v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support
Date: Sun,  4 May 2014 11:41:39 -0400
Message-Id: <20140504154149.160535082@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit bc826d6e39fe5f09cbadf8723e9183e6331b586f upstream.

The wrong ioctl numbers were used due to a copy-and-paste error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -787,8 +787,8 @@ static int put_v4l2_subdev_edid32(struct
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


