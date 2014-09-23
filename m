Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaIWKrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:47:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47399 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070AbaIWKrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:47:20 -0400
Date: Tue, 23 Sep 2014 11:46:41 +0100
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <rric@kernel.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH v3 0/4] arm64, thunder: Enable Cavium Thunder SoC Family
Message-ID: <20140923104641.GF26472@arm.com>
References: <1410544187-15876-1-git-send-email-rric@kernel.org>
 <20140923104122.GE20170@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923104122.GE20170@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Tue, Sep 23, 2014 at 11:41:22AM +0100, Robert Richter wrote:
> On 12.09.14 19:49:43, Robert Richter wrote:
> > From: Robert Richter <rrichter@cavium.com>
> > 
> > This initial patches enable Cavium Thunder SoC Family. The patches add
> > devicetree and Kconfig support and then add Thunder to the defconfig.
> > 
> > The Thunder system needs more enablement patches for subsystems and
> > devices, this includes network, ahci, gicv3/gicv3-its, pci, smmu, kvm.
> > We will send separate patch sets for these. All of them base on this
> > initial patches.
> > 
> > I sent a separate patch set independently that introduces support for
> > dts vendor subdirs. After both patch sets have been applied I will
> > send a patch in addition that moves the dts file into a subdirectory.
> > 
> > I sent another separate patch that sets NR_CPUS to 64 per default.
> > 
> > The first patch introduces dts files without having a Kconfig option
> > for the soc (ARCH_THUNDER). However, this is introduced in patch 3 and
> > added to defconfig in patch 4 as this is my preferred solution. If
> > there is still resistance having an ARCH_THUNDER option, just drop
> > them.
> > 
> > Patches are available here:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git thunder/init
> 
> Will,
> 
> it would be good if these patches could be applied.

Catalin's handling the 3.18 merge window, but this looks like arm-soc
material anyway and should go via Olof/Arnd.

Will
