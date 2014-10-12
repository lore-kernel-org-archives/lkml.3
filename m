Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaJLUmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:42:19 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53128 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaJLUlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:11 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 14/15] media: davinci: vpbe: group v4l2_ioctl_ops
Date: Sun, 12 Oct 2014 21:40:44 +0100
Message-Id: <1413146445-7304-15-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch groups the v4l2_ioctl_ops.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index b57fa68..17c965d 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1252,11 +1252,14 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_cropcap		 = vpbe_display_cropcap,
 	.vidioc_g_crop		 = vpbe_display_g_crop,
 	.vidioc_s_crop		 = vpbe_display_s_crop,
+
 	.vidioc_s_std		 = vpbe_display_s_std,
 	.vidioc_g_std		 = vpbe_display_g_std,
+
 	.vidioc_enum_output	 = vpbe_display_enum_output,
 	.vidioc_s_output	 = vpbe_display_s_output,
 	.vidioc_g_output	 = vpbe_display_g_output,
+
 	.vidioc_s_dv_timings	 = vpbe_display_s_dv_timings,
 	.vidioc_g_dv_timings	 = vpbe_display_g_dv_timings,
 	.vidioc_enum_dv_timings	 = vpbe_display_enum_dv_timings,
-- 
1.9.1

