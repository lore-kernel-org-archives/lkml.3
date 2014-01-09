Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaAIRvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:51:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:1883 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaAIRvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:51:39 -0500
X-IronPort-AV: E=Sophos;i="4.95,632,1384300800"; 
   d="scan'208";a="89235786"
Date: Thu, 9 Jan 2014 17:50:44 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "nico@linaro.org" <nico@linaro.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>
Subject: Re: [PATCH v8 4/6] arm64: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING
 and pv_time_ops
In-Reply-To: <1389269716.27473.73.camel@kazak.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1401091750120.21510@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com>  <1389206998-27875-4-git-send-email-stefano.stabellini@eu.citrix.com>  <20140109121308.GH3081@arm.com> <1389269716.27473.73.camel@kazak.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014, Ian Campbell wrote:
> On Thu, 2014-01-09 at 12:13 +0000, Catalin Marinas wrote:
> > On Wed, Jan 08, 2014 at 06:49:56PM +0000, Stefano Stabellini wrote:
> > >  arch/arm64/Kconfig         |   20 ++++++++++++++++++++
> > >  arch/arm64/kernel/Makefile |    1 +
> > >  2 files changed, 21 insertions(+)
> > [...]
> > > diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> > > index 5ba2fd4..1dee735 100644
> > > --- a/arch/arm64/kernel/Makefile
> > > +++ b/arch/arm64/kernel/Makefile
> > > @@ -18,6 +18,7 @@ arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o
> > >  arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
> > >  arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
> > >  arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
> > > +arm64-obj-$(CONFIG_PARAVIRT)		+= paravirt.o
> > 
> > Did you forget a git add?
> 
> I was just about to say the same thing for the previous arm patch too.

That is what I get for still using patch queues :-/
