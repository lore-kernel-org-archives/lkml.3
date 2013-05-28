Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3E1LUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:20:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30606 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab3E1LUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:20:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,757,1363132800"; 
   d="scan'208";a="26379483"
Date: Tue, 28 May 2013 12:08:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>, <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL for 3.11] arm: introduce psci_smp_ops
In-Reply-To: <alpine.DEB.2.02.1305281205500.4799@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1305281208010.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305211522120.4799@kaball.uk.xensource.com> <alpine.DEB.2.02.1305281205500.4799@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise, I have seen now that you pulled
3.10-rc2-psci-ops-11-tag into "devel-stable".

Thanks,

Stefano


On Tue, 28 May 2013, Stefano Stabellini wrote:
> ping?
> 
> 
> On Tue, 21 May 2013, Stefano Stabellini wrote:
> > Russell,
> > please pull (based on v3.10-rc2):
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git 3.10-rc2-psci-ops-11-tag
> > 
> > 
> > It contains the generic PSCI patch and the smp_init patch that we
> > discussed so much about.
> > I think it would be helpful for other people if you could create a
> > stable branch with these patches so that SoC devs can base their work on
> > it.
> > 
> > 
> > Jon Medhurst (1):
> >       ARM: Enable selection of SMP operations at boot time
> > 
> > Stefano Stabellini (1):
> >       arm: introduce psci_smp_ops
> > 
> >  arch/arm/include/asm/mach/arch.h |    5 ++
> >  arch/arm/include/asm/psci.h      |    9 ++++
> >  arch/arm/kernel/Makefile         |    5 ++-
> >  arch/arm/kernel/psci.c           |    7 +--
> >  arch/arm/kernel/psci_smp.c       |   84 ++++++++++++++++++++++++++++++++++++++
> >  arch/arm/kernel/setup.c          |    9 ++++-
> >  arch/arm/mach-virt/Makefile      |    1 -
> >  arch/arm/mach-virt/platsmp.c     |   50 ----------------------
> >  arch/arm/mach-virt/virt.c        |    3 -
> >  9 files changed, 113 insertions(+), 60 deletions(-)
> >  create mode 100644 arch/arm/kernel/psci_smp.c
> >  delete mode 100644 arch/arm/mach-virt/platsmp.c
> > 
> 
