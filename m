Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3JXEQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 00:16:28 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:60715 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab3JXEQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 00:16:26 -0400
Date: Wed, 23 Oct 2013 22:16:20 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ashley Lai <adlai@linux.vnet.ibm.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Re: [tpmdd-devel] [PATCH] tpm: MAINTAINERS: Add myself as tpm
 maintainer
Message-ID: <20131024041620.GA32346@obsidianresearch.com>
References: <1382463410-2018-1-git-send-email-peterhuewe@gmx.de>
 <20131022205205.GA2374@obsidianresearch.com>
 <CAEQAOwoFpiVeDKTa6UgjiRoy9aKcUPHT7CYwa1eM1EUVm0gM=Q@mail.gmail.com>
 <trinity-2863d941-7421-4bbb-8c72-4bf491937d37-1382569828674@3capp-gmx-bs20>
 <20131024032736.GC30090@obsidianresearch.com>
 <1382587279.5587.9.camel@fishsauce>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382587279.5587.9.camel@fishsauce>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 11:01:19PM -0500, Ashley Lai wrote:
> 
> > Agreed, there are still lots of patches to go before the subsystem
> > meets the current kernel standard..
> > 
> > Speaking of which, has anyone looked at the rest of my series?? Shall
> > I repost it?
> 
> Jason,
>   Are you referring to the for-tpm branch on github?
> https://github.com/jgunthorpe/linux/commits/for-tpm
> Peter already submitted most of the patches to James from this branch.
> Let us know which series need to be review.

All of those patches in for-tpm have gone to James.

However, the original series I posted included 5 additional patches
that have received no comment, available on:

https://github.com/jgunthorpe/linux/commits/tpm-devel

Jason Gunthorpe:
      tpm: Pull everything related to /dev/tpmX into tpm-dev.c
      tpm: Pull everything related to sysfs into tpm-sysfs.c
      tpm: Create a tpm_class_ops structure and use it in the drivers
      tpm: Use the ops structure instead of a copy in tpm_vendor_specific
      tpm: Make tpm-dev allocate a per-file structure

These would have been posted as patch numbers 8 through 13 in the
original series.

I think what happened is at this point in the series module compile
broke. That is fixed now in the for-james pull, so the rest of the
series should be looked at.

Peter's checkpatch clean up will create some minor conflicts, so I
should probably resend the lot after rebasing it.

Jason
