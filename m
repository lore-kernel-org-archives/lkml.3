Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaCQCQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 22:16:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57203 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaCQCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 22:16:08 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-02-53265ae59aad
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'Kim'" <jaegeuk.kim@samsung.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
References: <5319A2D5.6060201@cn.fujitsu.com>
 <001801cf3e9c$ac3330d0$04999270$@samsung.com> <53218111.7040505@cn.fujitsu.com>
In-reply-to: <53218111.7040505@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH 3/5] f2fs: format segment_info's show for better
 legibility
Date: Mon, 17 Mar 2014 10:14:35 +0800
Message-id: <000c01cf4186$d770a2e0$8651e8a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQD92v1OX0voUOasBE+TELEevx2OewJBSKJ6AaoHyZ+cZ/v8sA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQd2nUWrBBjvmmFg8bz/AbHF9118m
	i0uL3C0u75rD5sDi8f/gJGaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqRLsgUv
	pSs6Pn5maWB8K9LFyMkhIWAi8Xb6VzYIW0ziwr31QDYXh5DAdEaJew9fMEE4Pxglnv/dClbF
	JqAisbzjPxOILSKgITFt6n6wImaBdkaJhWumghUJCdRLrJ/2jB3E5hTQk9h3tpMRxBYWiJH4
	vn43mM0ioCqxbflEsHpeAUuJqU+XsELYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGeJUBYkd
	Z18zQhzhJHHl4U9miBpxiY1HbrFMYBSahWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwVHwTHoH46oGi0OMAhyMSjy8E5TVgoVYE8uKK3MPMUpwMCuJ8CaYA4V4
	UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwWl2atsb/+4Rt
	kzb5e6s6LSjVetT24syyN+vn9fHutKrg0GJ8mmeR1Ll1fpP8s7kCkp4zbzeUBBsu/cD7Ven0
	kvn93pdnh7GtsTpQIuW+v0bz85JZbOzuMb5GPas3btJbKfuk/ozIxWazN4beKY7Nixqnvz0o
	NX/PmqMdy3pfbpvr9tb5srKhkBJLcUaioRZzUXEiAGsRGlB+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Thursday, March 13, 2014 5:58 PM
> To: Chao Yu
> Cc: 'Kim'; 'linux-kernel'; 'f2fs'
> Subject: Re: [f2fs-dev] [PATCH 3/5] f2fs: format segment_info's show for better legibility
> 
> Hi,
> On 03/13/2014 05:13 PM, Chao Yu wrote:
> 
> > Hi Gu,
> >
> >> -----Original Message-----
> >> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> >> Sent: Friday, March 07, 2014 6:44 PM
> >> To: Kim
> >> Cc: linux-kernel; f2fs
> >> Subject: [f2fs-dev] [PATCH 3/5] f2fs: format segment_info's show for better legibility
> >>
> >> The original segment_info's show is a bit out-of-format:
> >>
> >> [root@guz Demoes]# cat /proc/fs/f2fs/loop0/segment_info
> >> 0 0 0 0 0 0 0 0 0 0 0
> >> 0 0 0 0 0 0 0 0 0 0
> >> 0 0 0 0 0 0 0 0 0 0
> >> ......
> >> 0 0 0 0 0 0 0 0 0 0
> >> 0 0 1 0 0 1 [root@guz Demoes]#
> >>
> >> so we fix it here for better legibility.
> >> [root@guz Demoes]# cat /proc/fs/f2fs/loop0/segment_info
> >> 0 0 0 0 0 0 0 0 0 0
> >> 0 0 0 0 0 0 0 0 0 0
> >> 0 0 0 0 0 0 0 0 0 0
> >> ......
> >> 0 0 0 0 0 0 0 0 0 0
> >> 0 0 1 0 0 1
> >> [root@guz Demoes]#
> >
> > Here is one case, this looks not legible.
> >
> > 0 0 0 0 0 0 0 0 0 0
> > 1 0 0 0 0 0 0 0 0 0
> > 0 0 0 0 0 0 0 0 0 0
> > 0 0 0 0 0 0 0 0 0 0
> > 0 0 0 0 0 0 0 0 0 0
> > 0 0 0 0 0 0 509 512 512 512
> > 512 512 512 512 512 512 512 512 512 512
> > 512 512 512 512 331 278 0 0 0 0
> > 0 0 0 0 0 0 0 0 0 0
> > 0 0 0 0 0 0 0 512 512 512
> > 512 512 512 512 512 512 512 512 512 512
> > 0 512 512 512 512 512 512 1 0 512
> >
> > So how about modifying code as following?
> 
> >
> >>
> >> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> >
> > Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> >
> >> ---
> >>  fs/f2fs/super.c |    7 ++++---
> >>  1 files changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> >> index 72df734..6e4851c 100644
> >> --- a/fs/f2fs/super.c
> >> +++ b/fs/f2fs/super.c
> >> @@ -546,11 +546,12 @@ static int segment_info_seq_show(struct seq_file *seq, void *offset)
> >>
> >>  	for (i = 0; i < total_segs; i++) {
> >>  		seq_printf(seq, "%u", get_valid_blocks(sbi, i, 1));
> >
> > 		seq_printf(seq, "%-3u ", get_valid_blocks(sbi, i, 1));
> 
> Hmm, this patch has been applied to f2fs-dev tree, so maybe you can send a
> patch to enhance it directly!:)

Alright, I will send another patch to fix it. :)
Thanks.

> 
> Regards,
> Gu
> 
> >
> >> -		if (i != 0 && (i % 10) == 0)
> >> -			seq_puts(seq, "\n");
> >> +		if ((i % 10) == 9 || i == (total_segs - 1))
> >> +			seq_putc(seq, '\n');
> >>  		else
> >> -			seq_puts(seq, " ");
> >> +			seq_putc(seq, ' ');
> >>  	}
> >> +
> >>  	return 0;
> >>  }
> >>
> >> --
> >> 1.7.7
> >>
> >>
> >> ------------------------------------------------------------------------------
> >> Subversion Kills Productivity. Get off Subversion & Make the Move to Perforce.
> >> With Perforce, you get hassle-free workflows. Merge that actually works.
> >> Faster operations. Version large binaries.  Built-in WAN optimization and the
> >> freedom to use Git, Perforce or both. Make the move to Perforce.
> >> http://pubads.g.doubleclick.net/gampad/clk?id=122218951&iu=/4140/ostg.clktrk
> >> _______________________________________________
> >> Linux-f2fs-devel mailing list
> >> Linux-f2fs-devel@lists.sourceforge.net
> >> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> >
> >


