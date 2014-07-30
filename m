Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaG3Oak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:30:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42270 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbaG3Oag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:30:36 -0400
Date: Wed, 30 Jul 2014 15:30:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140730143037.GD8989@arm.com>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730110425.GI12239@arm.com>
 <20140730132348.GM29590@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730132348.GM29590@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 02:23:50PM +0100, Thierry Reding wrote:
> On Wed, Jul 30, 2014 at 12:04:25PM +0100, Will Deacon wrote:
> > On Fri, Jul 04, 2014 at 04:29:17PM +0100, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > This commit introduces a generic device tree binding for IOMMU devices.
> > > Only a very minimal subset is described here, but it is enough to cover
> > > the requirements of both the Exynos System MMU and Tegra SMMU as
> > > discussed here:
> > > 
> > >     https://lkml.org/lkml/2014/4/27/346
> > > 
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > > Changes in v4:
> > > - clarify that disabling an IOMMU DT node may not disable translation
> > > - be more explicit that examples are only examples
> > > - add multi-ID master example
> > > 
> > > Changes in v3:
> > > - use #iommu-cells instead of #address-cells/#size-cells
> > > - drop optional iommu-names property
> > > 
> > > Changes in v2:
> > > - add notes about "dma-ranges" property (drop note from commit message)
> > > - document priorities of "iommus" property vs. "dma-ranges" property
> > > - drop #iommu-cells in favour of #address-cells and #size-cells
> > > - remove multiple-master device example
> > > 
> > >  Documentation/devicetree/bindings/iommu/iommu.txt | 172 ++++++++++++++++++++++
> > >  1 file changed, 172 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
> > 
> > I'm concerned that this patch hasn't been picked up for 3.17 (I can't see it
> > in -next). If we want to move the ARM SMMU driver over to this new binding,
> > we can't keep dragging our feet for much longer as I *really* don't plan to
> > support two bindings in parallel (one is complicated enough already).
> > 
> > Any chance we can see this merged, please?
> 
> I think there weren't any comments left for me to address and I've
> mostly been waiting for Joerg to pick it up.
> 
> Joerg, can you take this through the iommu tree for 3.17? Will acked
> this, but perhaps you were waiting for an ACK from the device tree
> bindings maintainers?

Rob, Mark: can one or both of you take a look at this please?

Cheers,

Will
