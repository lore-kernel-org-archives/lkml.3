Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbaEPNkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:40:39 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50854 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbaEPNke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:40:34 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 20/49] media: davinci: vpif_display: group v4l2_ioctl_ops
Date: Fri, 16 May 2014 19:03:25 +0530
Message-Id: <1400247235-31434-22-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch gorups the v4l2_ioctl_ops and align them appropriately.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 9848996..401d03a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1032,11 +1032,11 @@ static int vpif_log_status(struct file *filep, void *priv)
 
 /* vpif display ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
-	.vidioc_querycap        	= vpif_querycap,
+	.vidioc_querycap		= vpif_querycap,
 	.vidioc_enum_fmt_vid_out	= vpif_enum_fmt_vid_out,
-	.vidioc_g_fmt_vid_out  		= vpif_g_fmt_vid_out,
-	.vidioc_s_fmt_vid_out   	= vpif_s_fmt_vid_out,
-	.vidioc_try_fmt_vid_out 	= vpif_try_fmt_vid_out,
+	.vidioc_g_fmt_vid_out		= vpif_g_fmt_vid_out,
+	.vidioc_s_fmt_vid_out		= vpif_s_fmt_vid_out,
+	.vidioc_try_fmt_vid_out		= vpif_try_fmt_vid_out,
 
 	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
 	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
@@ -1047,14 +1047,17 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_streamon		= vb2_ioctl_streamon,
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
-	.vidioc_s_std           	= vpif_s_std,
+	.vidioc_s_std			= vpif_s_std,
 	.vidioc_g_std			= vpif_g_std,
+
 	.vidioc_enum_output		= vpif_enum_output,
 	.vidioc_s_output		= vpif_s_output,
 	.vidioc_g_output		= vpif_g_output,
-	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
-	.vidioc_s_dv_timings            = vpif_s_dv_timings,
-	.vidioc_g_dv_timings            = vpif_g_dv_timings,
+
+	.vidioc_enum_dv_timings		= vpif_enum_dv_timings,
+	.vidioc_s_dv_timings		= vpif_s_dv_timings,
+	.vidioc_g_dv_timings		= vpif_g_dv_timings,
+
 	.vidioc_log_status		= vpif_log_status,
 };
 
-- 
1.7.9.5

