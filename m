Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaA3RPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:15:55 -0500
Received: from smtp.citrix.com ([66.165.176.89]:33155 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbaA3RPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:15:53 -0500
X-IronPort-AV: E=Sophos;i="4.95,751,1384300800"; 
   d="scan'208";a="98186355"
Message-ID: <1391102149.9495.39.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] arm: document "mach-virt" platform.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Christopher Covington <cov@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>
Date: Thu, 30 Jan 2014 17:15:49 +0000
In-Reply-To: <52EA83D6.9050506@codeaurora.org>
References: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
	 <52EA83D6.9050506@codeaurora.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 11:54 -0500, Christopher Covington wrote:
> > +++ b/Documentation/devicetree/bindings/arm/mach-virt.txt
> > @@ -0,0 +1,32 @@
> > +* Mach-virt "Dummy Virtual Machine" platform
> > +
> > +"mach-virt" is the smallest, dumbest platform possible, to be used as
> > +a guest for Xen, KVM and other hypervisors.
> 
> The platform is also useful to, and used by, simulators like QEMU in TCG mode.

I can mention this, although I don't think the list needs to be
exhaustive.
                                      It has no
> > +properties/functionality of its own and is driven entirely by device
> > +tree.
> 
> I find this wording confusing. I read it as saying the platform has no
> properties or functionality. Perhaps you could phrase it slightly differently,
> such as having no properties or functionality beyond what's described in the
> device tree.

Yes, this is what I was trying to say, I'll update with something along
those lines.

> > +The platform may also provide hypervisor specific functionality
> > +(e.g. PV I/O), if it does so then this functionality must be
> > +discoverable (directly or indirectly) via device tree.
> 
> I think it would be informative to provide pointers here to commonly used
> paravirtualized devices, especially VirtIO PCI/MMIO.

Under what criteria would something be eligible/appropriate to be
listed? I was trying to avoid "advocating" any particular type of PV
devices. We already have something of a problem with people incorrectly
assuming that mach-virt == virtio, which is not the case.

If we did want to include an explicit list here at a minimum I would
also want to include the Xen PV devices as well and surely there would
be others which ought to be included too.

Ian.

