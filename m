Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbaEPNmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:42 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39122 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaEPNmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:38 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 43/49] media: davinci: vpif_capture: group v4l2_ioctl_ops
Date: Fri, 16 May 2014 19:03:49 +0530
Message-Id: <1400247235-31434-46-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 113d333..9b41465 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1262,11 +1262,12 @@ static int vpif_log_status(struct file *filep, void *priv)
 
 /* vpif capture ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
-	.vidioc_querycap        	= vpif_querycap,
+	.vidioc_querycap		= vpif_querycap,
 	.vidioc_enum_fmt_vid_cap	= vpif_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap  		= vpif_g_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= vpif_g_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= vpif_s_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap		= vpif_try_fmt_vid_cap,
+
 	.vidioc_enum_input		= vpif_enum_input,
 	.vidioc_s_input			= vpif_s_input,
 	.vidioc_g_input			= vpif_g_input,
@@ -1281,13 +1282,14 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
 	.vidioc_querystd		= vpif_querystd,
-	.vidioc_s_std           	= vpif_s_std,
+	.vidioc_s_std			= vpif_s_std,
 	.vidioc_g_std			= vpif_g_std,
 
-	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
-	.vidioc_query_dv_timings        = vpif_query_dv_timings,
-	.vidioc_s_dv_timings            = vpif_s_dv_timings,
-	.vidioc_g_dv_timings            = vpif_g_dv_timings,
+	.vidioc_enum_dv_timings		= vpif_enum_dv_timings,
+	.vidioc_query_dv_timings	= vpif_query_dv_timings,
+	.vidioc_s_dv_timings		= vpif_s_dv_timings,
+	.vidioc_g_dv_timings		= vpif_g_dv_timings,
+
 	.vidioc_log_status		= vpif_log_status,
 };
 
-- 
1.7.9.5

