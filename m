Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab3GZWBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:01:00 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56294 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011Ab3GZWA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:00:57 -0400
Date: Fri, 26 Jul 2013 17:00:53 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-embedded@vger.kernel.org
References: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
	<51ECA17A.3060401@cn.fujitsu.com>
	<CAB3wodewRSGwKt_mKP7e-HpA=b7hCUedBsAcasFxWC5ZPJ5btg@mail.gmail.com>
	<51ECCB8B.7030104@cn.fujitsu.com>
In-Reply-To: <51ECCB8B.7030104@cn.fujitsu.com> (from guz.fnst@cn.fujitsu.com
	on Mon Jul 22 01:04:59 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1374876053.3031.19@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 01:04:59 AM, Gu Zheng wrote:
> On 07/22/2013 01:07 PM, Phillip Lougher wrote:
> 
> > On 22 July 2013 04:05, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> >> Hi Phillip,
> >>         Have some tests been carried out to confirm that Squashfs  
> really
> >> can get benefit from LZ4 compression, comparing with lzo?
> >
> > This seems to be a loaded question, in that it seems to be trying to
> > reopen the "why add lz4 when we already have lzo" debate all over
> > again.  As LZ4 has been merged to mainline, this appears to be a
> > question that has already been answered.
> 
> No, they are different. LZ4 can be merged to mainline, because we can
> see the benefit(faster compressing speed under the enabled unaligned
> memory access) it brings to us comparing with lzo.
> But it's hard to say that it also really can bring benefit to  
> Squashfs.

A compression format was added to the kernel. Philip hooked up the code  
that was already in the kernel to a filesystem that was already in the  
kernel.

You consider this action controversial...

Rob