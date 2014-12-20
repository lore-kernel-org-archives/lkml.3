Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaLTKtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:49:32 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63249 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaLTKs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:59 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 14/15] media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
Date: Sat, 20 Dec 2014 16:17:41 +0530
Message-Id: <1419072462-3168-15-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support for VIDIOC_EXPBUF.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 858e333..ff89bae 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -763,6 +763,7 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_querybuf         = vb2_ioctl_querybuf,
 	.vidioc_qbuf             = vb2_ioctl_qbuf,
 	.vidioc_dqbuf            = vb2_ioctl_dqbuf,
+	.vidioc_expbuf           = vb2_ioctl_expbuf,
 	.vidioc_streamon         = vb2_ioctl_streamon,
 	.vidioc_streamoff        = vb2_ioctl_streamoff,
 	.vidioc_g_parm           = bcap_g_parm,
-- 
1.9.1

