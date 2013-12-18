Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3LRQj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:39:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:11832 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3LRQjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:39:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="454320492"
Date: Wed, 18 Dec 2013 21:10:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] dma: mv_xor: remove mv_desc_get_dest_addr()
Message-ID: <20131218154045.GC16227@intel.com>
References: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
 <20131128055706.GM8834@intel.com>
 <20131209235035.GA11632@n2100.arm.linux.org.uk>
 <20131210101331.GG29580@intel.com>
 <20131210111449.GY4360@n2100.arm.linux.org.uk>
 <CAPcyv4gAazGS_m6KNfF2_kY3CDzYkvpBQ=kcnPH-pBvcJ0HjAw@mail.gmail.com>
 <CAPcyv4iNOqHSQXj_PTmG-iHajnmHoPhLeFvnnK-JtNykf2W3Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iNOqHSQXj_PTmG-iHajnmHoPhLeFvnnK-JtNykf2W3Ew@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:00:05PM -0800, Dan Williams wrote:
> On Wed, Dec 11, 2013 at 1:10 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Tue, Dec 10, 2013 at 3:14 AM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> >> On Tue, Dec 10, 2013 at 03:43:31PM +0530, Vinod Koul wrote:
> >>> On Mon, Dec 09, 2013 at 11:50:35PM +0000, Russell King - ARM Linux wrote:
> >>> > On Thu, Nov 28, 2013 at 11:27:06AM +0530, Vinod Koul wrote:
> >>> > > + Dan
> >>> > >
> >>> > > On Mon, Nov 25, 2013 at 07:39:25PM +0000, Jason Cooper wrote:
> >>> > > > The following commit:
> >>> > > >
> >>> > > >   54f8d501e842 dmaengine: remove DMA unmap from drivers
> >>> > > >
> >>> > > > removed the last caller to mv_desc_get_dest_addr(), creating the
> >>> > > > warning:
> >>> > > >
> >>> > > >   drivers/dma/mv_xor.c:57:12: warning: 'mv_desc_get_dest_addr' defined
> >>> > > >   but not used [-Wunused-function]
> >>> > > >
> >>> > > > Remove it.
> >>> > > >
> >>> > > > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> >>> > > Acked-by: Vinod Koul <vinod.koul@intel.com>
> >>> > >
> >>> > > This should go thru Dan's tree
> >>> >
> >>> > So what's happening with this patch?  I don't see it in -rc yet.
> >>> Dan has applied this to his next. So this should show us in next rc1
> >>
> >> Wrong answer.  This is a compile regression introduced in the last merge
> >> window, it should be going into an -rc kernel.
> >
> > Vinod, if your fixes branch is ready I'll take it along with the rest
> > of the regression fixes to Linus.
Sorry I wasnt well last week, so I just managed to send the PULL on friday
morning. Wasnt sure if Linus will cut rc on friday or later, so sent it!
> 
> Ok, I see you sent dma-slave/fixes up, I'll follow up with the rest:
Okay, did you manage to send it? If not I may have few (i think at least 1 more)

--
~Vinod
> 
> Dan Williams (5):
>       dma: fix build warnings in ppc4xx
>       dma: fix fsldma build warnings
>       dmatest: fix build warning on mips
>       dma: fix build warnings in txx9
>       dmaengine: fix enable for high order unmap pools
> 
> Ezequiel Garcia (1):
>       dma: mv_xor: Use dmaengine_unmap_data for the self-tests
> 
> Jason Cooper (1):
>       dma: mv_xor: remove mv_desc_get_dest_addr()
> 
> Olof Johansson (1):
>       dmaengine: at_hdmac: remove unused function
> 
> Russell King (1):
>       dmaengine: mv_xor: fix oops when channels fail to initialise

-- 
