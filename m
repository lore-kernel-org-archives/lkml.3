Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaJLUmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:42:42 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33646 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaJLUlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:08 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 11/15] media: davinci: vpbe: add support for VIDIOC_EXPBUF
Date: Sun, 12 Oct 2014 21:40:41 +0100
Message-Id: <1413146445-7304-12-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index fd8d4f0..378f31b 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1261,6 +1261,7 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_streamon	 = vb2_ioctl_streamon,
 	.vidioc_streamoff	 = vb2_ioctl_streamoff,
 	.vidioc_create_bufs	 = vb2_ioctl_create_bufs,
+	.vidioc_expbuf		 = vb2_ioctl_expbuf,
 
 	.vidioc_cropcap		 = vpbe_display_cropcap,
 	.vidioc_g_crop		 = vpbe_display_g_crop,
-- 
1.9.1

