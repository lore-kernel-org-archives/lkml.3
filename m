Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJYXIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 19:08:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaJYXIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 19:08:30 -0400
Message-ID: <544C2D67.8000405@suse.de>
Date: Sun, 26 Oct 2014 01:08:23 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: suravee.suthikulpanit@amd.com
CC: mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com,
        marc.zyngier@arm.com, liviu.dudau@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.14 14:20, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Initial revision of device tree for AMD Seattle platform
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
> ---
>  arch/arm64/Kconfig                          |   5 +
>  arch/arm64/boot/dts/Makefile                |   1 +
>  arch/arm64/boot/dts/amd-seattle-periph.dtsi | 164 ++++++++++++++++++++++++++++
>  arch/arm64/boot/dts/amd-seattle.dts         | 126 +++++++++++++++++++++
>  4 files changed, 296 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 48b7437..e4c052f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -137,6 +137,11 @@ source "kernel/Kconfig.freezer"
>  
>  menu "Platform selection"
>  
> +config ARCH_SEATTLE
> +	bool "AMD Seattle SoC Family"
> +	help
> +	  This enables support for AMD Seattle SOC Family
> +
>  config ARCH_THUNDER
>  	bool "Cavium Inc. Thunder SoC Family"
>  	help
> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> index f8001a6..6c27047 100644
> --- a/arch/arm64/boot/dts/Makefile
> +++ b/arch/arm64/boot/dts/Makefile
> @@ -1,6 +1,7 @@
>  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb

This option doesn't exist in upstream kernels, does it? Why not just
make it dtb-y?


Alex

