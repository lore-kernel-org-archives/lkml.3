Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaAIMPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:15:24 -0500
Received: from smtp.citrix.com ([66.165.176.89]:35085 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaAIMPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:15:20 -0500
X-IronPort-AV: E=Sophos;i="4.95,630,1384300800"; 
   d="scan'208";a="91246180"
Message-ID: <1389269716.27473.73.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH v8 4/6] arm64: introduce CONFIG_PARAVIRT,
 PARAVIRT_TIME_ACCOUNTING and pv_time_ops
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
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
Date: Thu, 9 Jan 2014 12:15:16 +0000
In-Reply-To: <20140109121308.GH3081@arm.com>
References: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com>
	 <1389206998-27875-4-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20140109121308.GH3081@arm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 12:13 +0000, Catalin Marinas wrote:
> On Wed, Jan 08, 2014 at 06:49:56PM +0000, Stefano Stabellini wrote:
> >  arch/arm64/Kconfig         |   20 ++++++++++++++++++++
> >  arch/arm64/kernel/Makefile |    1 +
> >  2 files changed, 21 insertions(+)
> [...]
> > diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> > index 5ba2fd4..1dee735 100644
> > --- a/arch/arm64/kernel/Makefile
> > +++ b/arch/arm64/kernel/Makefile
> > @@ -18,6 +18,7 @@ arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o
> >  arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
> >  arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
> >  arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
> > +arm64-obj-$(CONFIG_PARAVIRT)		+= paravirt.o
> 
> Did you forget a git add?

I was just about to say the same thing for the previous arm patch too.

Ian.



