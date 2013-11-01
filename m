Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3KALmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:42:32 -0400
Received: from 8bytes.org ([85.214.48.195]:37958 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab3KALma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:42:30 -0400
Date: Fri, 1 Nov 2013 12:42:24 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v10 00/20] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Message-ID: <20131101114224.GG17455@8bytes.org>
References: <20131007105212.1c2a9e29166ff4b4a33468f8@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007105212.1c2a9e29166ff4b4a33468f8@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Nov  1 12:42:28 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 527393a420861889615283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:52:12AM +0900, Cho KyongHo wrote:
> Patch summary:
> [PATCH 01/20] iommu/exynos: do not include removed header
> [PATCH 02/20] iommu/exynos: add missing cache flush for removed page table entries
> [PATCH 03/20] iommu/exynos: change error handling when page table update is failed
> [PATCH 04/20] iommu/exynos: fix L2TLB invalidation
> [PATCH 05/20] iommu/exynos: allocate lv2 page table from own slab
> [PATCH 06/20] iommu/exynos: always enable runtime PM
> [PATCH 07/20] iommu/exynos: always use a single clock descriptor
> [PATCH 08/20] iommu/exynos: remove dbgname from drvdata of a System MMU
> [PATCH 09/20] iommu/exynos: use managed device helper functions
> [PATCH 10/20] clk: exynos: add gate clock descriptions of System MMU
> [PATCH 11/20] ARM: dts: Add description of System MMU of Exynos SoCs
> [PATCH 12/20] iommu/exynos: support for device tree
> [PATCH 13/20] iommu/exynos: gating clocks of master H/W
> [PATCH 14/20] iommu/exynos: remove custom fault handler
> [PATCH 15/20] iommu/exynos: remove calls to Runtime PM API functions
> [PATCH 16/20] iommu/exynos: turn on useful configuration options
> [PATCH 17/20] iommu/exynos: add support for power management subsystems.
> [PATCH 18/20] iommu/exynos: change rwlock to spinlock
> [PATCH 19/20] iommu/exynos: return 0 if iommu_attach_device() successes
> [PATCH 20/20] iommu/exynos: add devices attached to the System MMU to an IOMMU group
> 
> Diffstats:
>  .../devicetree/bindings/clock/exynos5250-clock.txt |   28 +
>  .../devicetree/bindings/clock/exynos5420-clock.txt |    3 +
>  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |   76 ++
>  arch/arm/boot/dts/exynos4.dtsi                     |  105 ++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   21 +
>  arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++
>  arch/arm/boot/dts/exynos5250.dtsi                  |  262 +++++
>  arch/arm/boot/dts/exynos5420.dtsi                  |  296 ++++++
>  drivers/clk/samsung/clk-exynos5250.c               |   49 +-
>  drivers/clk/samsung/clk-exynos5420.c               |   12 +-
>  drivers/iommu/Kconfig                              |    5 +-
>  drivers/iommu/exynos-iommu.c                       | 1033 +++++++++++++-------
>  12 files changed, 1585 insertions(+), 387 deletions(-)

What is the state of this series? It would be good to have some
Acked-bys and/or Reviewed-bys on it.


	Joerg


