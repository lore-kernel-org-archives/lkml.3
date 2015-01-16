Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbbAPPI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:08:59 -0500
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37669 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbbAPPI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:08:58 -0500
Message-ID: <54B92976.1060501@xs4all.nl>
Date: Fri, 16 Jan 2015 16:08:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 00/15] media: blackfin: bfin_capture enhancements
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com> <CAHG8p1DxTmd6QDpmjHSG0+40GaeGV0ox0aZpX_VVxTJUnxhB1A@mail.gmail.com>
In-Reply-To: <CAHG8p1DxTmd6QDpmjHSG0+40GaeGV0ox0aZpX_VVxTJUnxhB1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

Any idea when you will have time to test this?

Regards,

	Hans

On 12/26/2014 08:13 AM, Scott Jiang wrote:
> Hi Lad,
> 
> I'm on holiday these days. I will test these patches later.
> 
> Thanks,
> Scott
> 
> 2014-12-20 18:47 GMT+08:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
>> Hi Scott,
>>
>> Although I was on holiday but couldn't resist myself from working,
>> since I was away from my hardware I had to choose a different one,
>> blackfin driver was lucky one. Since I don't have the blackfin
>> board I haven't tested them on the actual board, but just compile
>> tested, Can you please test it & ACK.
>>
>> Lad, Prabhakar (15):
>>   media: blackfin: bfin_capture: drop buf_init() callback
>>   media: blackfin: bfin_capture: release buffers in case
>>     start_streaming() call back fails
>>   media: blackfin: bfin_capture: set min_buffers_needed
>>   media: blackfin: bfin_capture: improve buf_prepare() callback
>>   media: blackfin: bfin_capture: improve queue_setup() callback
>>   media: blackfin: bfin_capture: use vb2_fop_mmap/poll
>>   media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
>>   media: blackfin: bfin_capture: use vb2_ioctl_* helpers
>>   media: blackfin: bfin_capture: make sure all buffers are returned on
>>     stop_streaming() callback
>>   media: blackfin: bfin_capture: return -ENODATA for *std calls
>>   media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
>>   media: blackfin: bfin_capture: add support for vidioc_create_bufs
>>   media: blackfin: bfin_capture: add support for VB2_DMABUF
>>   media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
>>   media: blackfin: bfin_capture: set v4l2 buffer sequence
>>
>>  drivers/media/platform/blackfin/bfin_capture.c | 310 ++++++++-----------------
>>  1 file changed, 98 insertions(+), 212 deletions(-)
>>
>> --
>> 1.9.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

