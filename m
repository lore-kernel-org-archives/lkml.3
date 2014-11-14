Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935038AbaKNEIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:08:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51485 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512AbaKNEIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:08:15 -0500
Message-ID: <54657FFA.1070200@ti.com>
Date: Fri, 14 Nov 2014 09:37:22 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Add support for ADC on am437x-gp and am43x-epos-evm
References: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
In-Reply-To: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 04 November 2014 04:45 PM, Vignesh R wrote:
> This series of patches enable ADC on am437x-gp-evm and am43x-epos-evm.
> The ADC clock hwmod data of am33xx has been moved to commom place so that
> both am43xx and am33xx can reuse them.
> tscadc DT node has been adided to am437x-gp and am43x-epos dt files.
> With these patches, ADC functionalities are now available on am43xx.
> 
> Changelog:
> 
> v2:
> Removed phy addresses in hwmod. Using DT instead.
> Removed unused "ti,am4372" compatible string.
> Use macro to set clk domain name.
> Fixed subject format of all patches
> 

Please accept these patches.

Regards
Vignesh R

> Vignesh R (3):
>   ARM: OMAP2+: hwmod: AM335x/AM43x: Move am33xx_l4_hs_hwmod to
>     ipblock_data
>   ARM: OMAP2+: hwmod: AM335x/AM43x: add hwmod support for tscadc on
>     am43x-evm
>   ARM: dts: AM43xx: add tscadc DT entries for am437x-evm and
>     am43x-epos-evm
> 
>  arch/arm/boot/dts/am4372.dtsi                      | 20 ++++++
>  arch/arm/boot/dts/am437x-gp-evm.dts                |  8 +++
>  arch/arm/boot/dts/am43x-epos-evm.dts               |  8 +++
>  .../mach-omap2/omap_hwmod_33xx_43xx_common_data.h  |  2 +
>  .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c | 71 ++++++++++++++++++++++
>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c         | 64 -------------------
>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c         |  1 +
>  7 files changed, 110 insertions(+), 64 deletions(-)
> 
