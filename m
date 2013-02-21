Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3BUNao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:30:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47623 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3BUNam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:30:42 -0500
Date: Thu, 21 Feb 2013 13:28:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] memory: tegra_ahb_enable_smmu() depends on
	TEGRA_IOMMU_SMMU
Message-ID: <20130221132851.GB17833@n2100.arm.linux.org.uk>
References: <1360175666-8377-1-git-send-email-hdoyu@nvidia.com> <5112A642.1020800@wwwdotorg.org> <20130206.211635.744922728615926717.hdoyu@nvidia.com> <20130211.193034.1346903263789032239.hdoyu@nvidia.com> <51250DDE.7010408@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51250DDE.7010408@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 10:54:38AM -0700, Stephen Warren wrote:
> On 02/11/2013 10:30 AM, Hiroshi Doyu wrote:
> > Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Wed, 06 Feb 2013 21:16:35 +0200 (EET):
> > 
> >> Hi Russell,
> >>
> >> Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 6 Feb 2013 19:51:46 +0100:
> >>
> >>> On 02/06/2013 11:34 AM, Hiroshi Doyu wrote:
> >>>> New SoC, Tegra114 also uses SMMU. Change tegra_ahb_enable_smmu()'s
> >>>> dependency from ARCH_TEGRA_3x_SOC to TEGRA_IOMMU_SMMU. No need to edit
> >>>> whenever a new Tegra SoC comes.
> >>>>
> >>>> The following combination caused build error, which this patch fixes.
> >>>>
> >>>> CONFIG_ARCH_TEGRA_2x_SOC=y
> >>>> \# CONFIG_ARCH_TEGRA_3x_SOC is not set
> >>>> CONFIG_ARCH_TEGRA_114_SOC=y
> >>>>
> >>>> drivers/iommu/tegra-smmu.c:485: undefined reference to 'tegra_ahb_enable_smmu'
> >>>
> >>> Tested-by: Stephen Warren <swarren@nvidia.com>
> >>>
> >>> Russell, I assume Hiroshi should upload this to your patch tracker? It's
> >>> needed for 3.9.
> >>
> >> FYI: Submitted as:
> >> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7640/1
> > 
> > Russell,
> > 
> > Is the above ok for you?
> > Please let me know if still I need to do something.
> 
> Russell, will this patch make it into your tree for 3.9? Do you think it
> should go through some other tree? Thanks.

I'll merge it, and I think it's a minor fix.  Should it be copied to
stable?  If so, which ones are affected?
