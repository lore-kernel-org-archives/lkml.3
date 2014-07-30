Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaG3NdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:33:13 -0400
Received: from 8bytes.org ([81.169.241.247]:58721 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaG3NdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:33:12 -0400
Date: Wed, 30 Jul 2014 15:33:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Arnd Bergmann <arnd@arndb.de>, Thierry Reding <thierry.reding@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
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
        arm@kernel.org
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140730133309.GF9809@8bytes.org>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730110425.GI12239@arm.com>
 <20140730132348.GM29590@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730132348.GM29590@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 03:23:50PM +0200, Thierry Reding wrote:
> I think there weren't any comments left for me to address and I've
> mostly been waiting for Joerg to pick it up.
> 
> Joerg, can you take this through the iommu tree for 3.17? Will acked
> this, but perhaps you were waiting for an ACK from the device tree
> bindings maintainers?
> 
> Will, perhaps you can get Pawel or Mark to look at this?
> 
> Arnd, I'm sure if we had your Acked-by that would go a long way too.

Yes, as Arnd requested this generic binding it would be good to have his
Acked-by before proceeding. Arnd?


	Joerg

