Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3IEQyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:54:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:48899 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3IEQyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:54:46 -0400
X-IronPort-AV: E=Sophos;i="4.90,848,1371081600"; 
   d="scan'208";a="50923542"
Date: Thu, 5 Sep 2013 17:54:15 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v5 03/13] arm64: define DMA_ERROR_CODE
In-Reply-To: <20130905160536.GH11887@arm.com>
Message-ID: <alpine.DEB.2.02.1309051752500.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com> <1377801154-29215-3-git-send-email-stefano.stabellini@eu.citrix.com> <20130905160536.GH11887@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013, Catalin Marinas wrote:
> On Thu, Aug 29, 2013 at 07:32:24PM +0100, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: catalin.marinas@arm.com
> > CC: will.deacon@arm.com
> > ---
> >  arch/arm64/include/asm/dma-mapping.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> > index 8d18100..c2cb8a0 100644
> > --- a/arch/arm64/include/asm/dma-mapping.h
> > +++ b/arch/arm64/include/asm/dma-mapping.h
> > @@ -25,6 +25,7 @@
> >  
> >  #define ARCH_HAS_DMA_GET_REQUIRED_MASK
> >  
> > +#define DMA_ERROR_CODE	(~0)
> 
> I wonder why this isn't more generic. It looks like most (all?)
> architectures define it in the same way.

Actually it's defined as 0 on x86 and ia64.
All the others define it as ~0.
