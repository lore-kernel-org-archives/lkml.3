Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaAIMNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:13:46 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:26135 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751086AbaAIMNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:13:38 -0500
Date: Thu, 9 Jan 2014 12:13:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "nico@linaro.org" <nico@linaro.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>
Subject: Re: [PATCH v8 4/6] arm64: introduce CONFIG_PARAVIRT,
 PARAVIRT_TIME_ACCOUNTING and pv_time_ops
Message-ID: <20140109121308.GH3081@arm.com>
References: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com>
 <1389206998-27875-4-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389206998-27875-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 06:49:56PM +0000, Stefano Stabellini wrote:
>  arch/arm64/Kconfig         |   20 ++++++++++++++++++++
>  arch/arm64/kernel/Makefile |    1 +
>  2 files changed, 21 insertions(+)
[...]
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 5ba2fd4..1dee735 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -18,6 +18,7 @@ arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o
>  arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
>  arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
>  arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
> +arm64-obj-$(CONFIG_PARAVIRT)		+= paravirt.o

Did you forget a git add?

-- 
Catalin
