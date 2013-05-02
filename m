Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab3EBRMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:12:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:44396 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757568Ab3EBRMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:12:18 -0400
X-IronPort-AV: E=Sophos;i="4.87,597,1363132800"; 
   d="scan'208";a="22962512"
Date: Thu, 2 May 2013 18:12:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v10 0/2] (arm-soc for v3.10) arm: introduce
 psci_smp_ops
In-Reply-To: <alpine.DEB.2.02.1304301707290.5398@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1305021811560.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304301707290.5398@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On Tue, 30 Apr 2013, Stefano Stabellini wrote:
> Hi all,
> this is the tenth version of the patch series to move virt_smp_ops out
> of mach-virt and make it a generic set of reusable PSCI based smp_ops.
> psci_smp_ops are preferred over the platform smp_ops.  The last patch
> introduces smp_init.
> 
> Changes in v10:
> - add include <linux/types.h> to mach/arch.h.
> 
> 
> 
> Jon Medhurst (1):
>       ARM: Enable selection of SMP operations at boot time
> 
> Stefano Stabellini (1):
>       arm: introduce psci_smp_ops
> 
>  arch/arm/include/asm/mach/arch.h |    5 ++
>  arch/arm/include/asm/psci.h      |    9 ++++
>  arch/arm/kernel/Makefile         |    5 ++-
>  arch/arm/kernel/psci.c           |    7 +--
>  arch/arm/kernel/psci_smp.c       |   90 ++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/setup.c          |    9 +++-
>  arch/arm/mach-virt/Makefile      |    1 -
>  arch/arm/mach-virt/platsmp.c     |   58 ------------------------
>  arch/arm/mach-virt/virt.c        |    3 -
>  9 files changed, 119 insertions(+), 68 deletions(-)
>  create mode 100644 arch/arm/kernel/psci_smp.c
>  delete mode 100644 arch/arm/mach-virt/platsmp.c
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git 3.9-rc3-psci-ops-10-tag
> 
> Cheers,
> 
> Stefano
> 
