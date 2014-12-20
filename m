Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaLTKsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:48:09 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58406 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaLTKsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:04 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 00/15] media: blackfin: bfin_capture enhancements
Date: Sat, 20 Dec 2014 16:17:27 +0530
Message-Id: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

Although I was on holiday but couldn't resist myself from working,
since I was away from my hardware I had to choose a different one,
blackfin driver was lucky one. Since I don't have the blackfin
board I haven't tested them on the actual board, but just compile
tested, Can you please test it & ACK.

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

 drivers/media/platform/blackfin/bfin_capture.c | 310 ++++++++-----------------
 1 file changed, 98 insertions(+), 212 deletions(-)

-- 
1.9.1

