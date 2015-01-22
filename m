Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbbAVWYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:24:17 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65395 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAVWVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:21:01 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 14/15] media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
Date: Thu, 22 Jan 2015 22:18:47 +0000
Message-Id: <1421965128-10470-15-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support for VIDIOC_EXPBUF.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 876db4b..f154f25 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -764,6 +764,7 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_querybuf         = vb2_ioctl_querybuf,
 	.vidioc_qbuf             = vb2_ioctl_qbuf,
 	.vidioc_dqbuf            = vb2_ioctl_dqbuf,
+	.vidioc_expbuf           = vb2_ioctl_expbuf,
 	.vidioc_streamon         = vb2_ioctl_streamon,
 	.vidioc_streamoff        = vb2_ioctl_streamoff,
 	.vidioc_g_parm           = bcap_g_parm,
-- 
2.1.0

