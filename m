Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbbAUMKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:10:03 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:46019 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbbAUMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:09:54 -0500
MIME-Version: 1.0
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 21 Jan 2015 12:09:21 +0000
Message-ID: <CA+V-a8ur2KV_s5zM9qbQZ+MLvocO9AE0KduWb3R-rUhA9912cw@mail.gmail.com>
Subject: Re: [PATCH 00/15] media: blackfin: bfin_capture enhancements
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

On Sat, Dec 20, 2014 at 10:47 AM, Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
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
If you are done with the review of all the patches,should I go ahead
and post a v2 fixing the two issues which you pointed out ?

Thanks,
--Prabhakar Lad
