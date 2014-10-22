Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaJVPUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:20:22 -0400
Received: from 8bytes.org ([81.169.241.247]:37039 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaJVPUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:20:20 -0400
Date: Wed, 22 Oct 2014 17:20:19 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Simon Xue <xxm@rock-chips.com>,
        Grant Grundler <grundler@chromium.org>,
        =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 0/3] Rockchip IOMMU driver and devicetree bindings
Message-ID: <20141022152019.GK10074@8bytes.org>
References: <1412158843-8115-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412158843-8115-1-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 06:20:40PM +0800, Daniel Kurtz wrote:
> Add a driver and devicetree bindings for the IOMMU found in Rockchip RK3288
> SoCs.
> 
> Daniel Kurtz (3):
>   iommu/rockchip: rk3288 iommu driver
>   dt-bindings: iommu: Add documentation for rockchip iommu
>   ARM: dts: rk3288: add VOP iommu nodes
> 
>  .../devicetree/bindings/iommu/rockchip,iommu.txt   |  26 +
>  arch/arm/boot/dts/rk3288.dtsi                      |  18 +
>  drivers/iommu/Kconfig                              |  11 +
>  drivers/iommu/Makefile                             |   1 +
>  drivers/iommu/rockchip-iommu.c                     | 924 +++++++++++++++++++++
>  5 files changed, 980 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
>  create mode 100644 drivers/iommu/rockchip-iommu.c

Please make sure you also get Acks for the DT bindings. With that and
the issue I mentioned in the other email fixed, I will apply these
patches?


	Joerg

