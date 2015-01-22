Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbbAVWUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:20:45 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59256 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbAVWUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:43 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 00/15] media: blackfin: bfin_capture enhancements
Date: Thu, 22 Jan 2015 22:18:33 +0000
Message-Id: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series, enhances blackfin capture driver with
vb2 helpers.

Changes for v2:
--------------
Only patches 5/15 and 8/15 as per Scott's suggestions.

Lad, Prabhakar (15):
  media: blackfin: bfin_capture: drop buf_init() callback
  media: blackfin: bfin_capture: release buffers in case
    start_streaming() call back fails
  media: blackfin: bfin_capture: set min_buffers_needed
  media: blackfin: bfin_capture: improve buf_prepare() callback
  media: blackfin: bfin_capture: improve queue_setup() callback
  media: blackfin: bfin_capture: use vb2_fop_mmap/poll
  media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
  media: blackfin: bfin_capture: use vb2_ioctl_* helpers
  media: blackfin: bfin_capture: make sure all buffers are returned on
    stop_streaming() callback
  media: blackfin: bfin_capture: return -ENODATA for *std calls
  media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
  media: blackfin: bfin_capture: add support for vidioc_create_bufs
  media: blackfin: bfin_capture: add support for VB2_DMABUF
  media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
  media: blackfin: bfin_capture: set v4l2 buffer sequence

 drivers/media/platform/blackfin/bfin_capture.c | 311 ++++++++-----------------
 1 file changed, 99 insertions(+), 212 deletions(-)

-- 
2.1.0

