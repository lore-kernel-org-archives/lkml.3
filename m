Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3GHCl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:41:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:51962 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3GHClz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:41:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1016,1363158000"; 
   d="scan'208";a="265217099"
Date: Mon, 8 Jul 2013 07:32:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>
Subject: Re: [GIT PULL] slave-dmaengine updates
Message-ID: <20130708020258.GD16653@intel.com>
References: <20130707041714.GB16653@intel.com>
 <CA+55aFw3c2RO-MeocJ0YL_pEy3X1+mAwvQBeVAiND9ia6M-vJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw3c2RO-MeocJ0YL_pEy3X1+mAwvQBeVAiND9ia6M-vJA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 02:39:18PM -0700, Linus Torvalds wrote:
> On Sat, Jul 6, 2013 at 9:17 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> >
> > Once you have some time from extended weekend celebrations please consider
> > pulling the following to get:
> > - Various fixes and PCI driver for dw_dmac by Andy
> > - DT binding for imx-dma by Markus & imx-sdma by Shawn
> > - DT fixes for dmaengine by Lars
> > - jz4740 dmac driver by Lars
> > - and various fixes across the drivers
> 
> Sadly, I noticed much too late that I should have checked the
> time-stamps on this too. Almost all of the commits seem to have been
> rebased recently. Not quite minutes before the pull request, but 90%
> of the commits seem to have been created long after the merge window
> opened.
I should have mentioned in my pull request. I had to rebase many commits as
there were some duplicate due to bad merge on my part. Wouldnt have been good
idea to send you along with thses. All these have been in -next for quite some
time

> 
> I have already pushed this out so it's too late now, but if I had
> noticed earlier I would have rejected this pull too.

> Today has not been a good day for pulling. If it wasn't for the
> __cpuinit removal pull, I wouldn't have had *anything* today that did
> things properly.
> 
>                      Linus "very annoyed" Torvalds
Thanks a bunch for merging
Sorry, will try to ensure its Linus "very happy" Torvalds next time...


Thanks
~Vinod

-- 
