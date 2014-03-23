Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaCWHE5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 03:04:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaCWHEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 03:04:54 -0400
Date: Sun, 23 Mar 2014 00:03:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux390@de.ibm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
Message-ID: <20140323070343.GA17945@infradead.org>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
 <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
 <1395543886.3460.95.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395543886.3460.95.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 02:04:46PM +1100, Benjamin Herrenschmidt wrote:
> 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 1594945..8122294 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -82,6 +82,7 @@ config ARM
> >  	  <http://www.arm.linux.org.uk/>.
> >  
> >  config ARM_HAS_SG_CHAIN
> > +	select ARCH_HAS_SG_CHAIN
> >  	bool
> >  
> 
> Heh, a self-selecting config option... I didn't know that trick !

ARM vs ARCH.  However the arm variant of the variable should probably be
consolidated into the ARCH one as a follow up.

