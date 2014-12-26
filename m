Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaLZHNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:13:55 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:54217 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaLZHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:13:54 -0500
MIME-Version: 1.0
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
Date: Fri, 26 Dec 2014 15:13:53 +0800
Message-ID: <CAHG8p1DxTmd6QDpmjHSG0+40GaeGV0ox0aZpX_VVxTJUnxhB1A@mail.gmail.com>
Subject: Re: [PATCH 00/15] media: blackfin: bfin_capture enhancements
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lad,

I'm on holiday these days. I will test these patches later.

Thanks,
Scott

2014-12-20 18:47 GMT+08:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
> Hi Scott,
>
> Although I was on holiday but couldn't resist myself from working,
> since I was away from my hardware I had to choose a different one,
> blackfin driver was lucky one. Since I don't have the blackfin
> board I haven't tested them on the actual board, but just compile
> tested, Can you please test it & ACK.
>
> Lad, Prabhakar (15):
>   media: blackfin: bfin_capture: drop buf_init() callback
>   media: blackfin: bfin_capture: release buffers in case
>     start_streaming() call back fails
>   media: blackfin: bfin_capture: set min_buffers_needed
>   media: blackfin: bfin_capture: improve buf_prepare() callback
>   media: blackfin: bfin_capture: improve queue_setup() callback
>   media: blackfin: bfin_capture: use vb2_fop_mmap/poll
>   media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
>   media: blackfin: bfin_capture: use vb2_ioctl_* helpers
>   media: blackfin: bfin_capture: make sure all buffers are returned on
>     stop_streaming() callback
>   media: blackfin: bfin_capture: return -ENODATA for *std calls
>   media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
>   media: blackfin: bfin_capture: add support for vidioc_create_bufs
>   media: blackfin: bfin_capture: add support for VB2_DMABUF
>   media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
>   media: blackfin: bfin_capture: set v4l2 buffer sequence
>
>  drivers/media/platform/blackfin/bfin_capture.c | 310 ++++++++-----------------
>  1 file changed, 98 insertions(+), 212 deletions(-)
>
> --
> 1.9.1
>
