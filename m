Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbbAVWYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:24:20 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:56333 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbbAVWU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:59 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 12/15] media: blackfin: bfin_capture: add support for vidioc_create_bufs
Date: Thu, 22 Jan 2015 22:18:45 +0000
Message-Id: <1421965128-10470-13-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support for vidioc_create_bufs.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 31b5697..b5b45e5 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -760,6 +760,7 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_query_dv_timings = bcap_query_dv_timings,
 	.vidioc_enum_dv_timings  = bcap_enum_dv_timings,
 	.vidioc_reqbufs          = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs      = vb2_ioctl_create_bufs,
 	.vidioc_querybuf         = vb2_ioctl_querybuf,
 	.vidioc_qbuf             = vb2_ioctl_qbuf,
 	.vidioc_dqbuf            = vb2_ioctl_dqbuf,
-- 
2.1.0

