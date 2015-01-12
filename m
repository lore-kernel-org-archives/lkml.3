Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbbALNAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:00:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59952 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbALNAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:00:33 -0500
Date: Mon, 12 Jan 2015 13:00:21 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Robin Murphy <Robin.Murphy@arm.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RESEND] dma-mapping: tidy up dma_parms default handling
Message-ID: <20150112130021.GC13360@arm.com>
References: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
 <2031542.TLqIP3YVGc@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2031542.TLqIP3YVGc@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 07:45:49PM +0000, Arnd Bergmann wrote:
> On Friday 09 January 2015 16:56:03 Robin Murphy wrote:
> > 
> > This one's a bit tricky to find a home for - I think technically it's 
> > probably an IOMMU patch, but then the long-underlying problem doesn't
> > seem to have blown up anything until arm64, and my motivation is to
> > make bits of Juno work, which seems to nudge it towards arm64/arm-soc
> > territory. Could anyone suggest which tree is most appropriate?
> 
> I have a set of patches touching various dma-mapping.h related bits
> across architectures and in ARM in particular. Your patch fits into
> that series, and I guess we could either have it in my asm-generic
> tree or in Andrew Morton's mm tree. Possibly also arm-soc for practical
> reasons, although it really doesn't belong in there.

I also have a couple of fixes for issues found by Laurent for tearing
down the IOMMU dma ops, so you could include those too.

I'll send them out this afternoon.

Will
