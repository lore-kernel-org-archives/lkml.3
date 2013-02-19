Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab3BSKeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:34:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43222 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652Ab3BSKeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:17 -0500
Message-ID: <5123556A.9050109@ti.com>
Date: Tue, 19 Feb 2013 16:05:22 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 8/8] ARM: dts: am43-pre-silicon support
References: <cover.1361186097.git.afzal@ti.com> <e344f74da47579c11db68d9f6efe25259ed7f25d.1361186097.git.afzal@ti.com>
In-Reply-To: <e344f74da47579c11db68d9f6efe25259ed7f25d.1361186097.git.afzal@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2013 05:08 PM, Afzal Mohammed wrote:
> AM43 SoC is in pre-silicon stage, meanwhile it has been modelled in
> a pre-silicon platform. To validate and boot Linux in pre-silicon
> platform that emulates an AM43 SoC, add DT build support.
>
> As bootloader is not used, bootargs is passed through DT.
>
> Note: This would be replaced by an original board support.
>
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
>   arch/arm/boot/dts/Makefile             |  3 ++-
>   arch/arm/boot/dts/am43-pre-silicon.dts | 31 +++++++++++++++++++++++++++++++
>   2 files changed, 33 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm/boot/dts/am43-pre-silicon.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 94d88b9..b434344 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -124,7 +124,8 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
>   	omap5-evm.dtb \
>   	am335x-evm.dtb \
>   	am335x-evmsk.dtb \
> -	am335x-bone.dtb
> +	am335x-bone.dtb \
> +	am43-pre-silicon.dtb
>   dtb-$(CONFIG_ARCH_ORION5X) += orion5x-lacie-ethernet-disk-mini-v2.dtb
>   dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
>   dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
> diff --git a/arch/arm/boot/dts/am43-pre-silicon.dts b/arch/arm/boot/dts/am43-pre-silicon.dts
> new file mode 100644
> index 0000000..b9c6297
> --- /dev/null
> +++ b/arch/arm/boot/dts/am43-pre-silicon.dts

Well the pre-silicon platform and the SOC are very
close and at least the support you are adding here is
exactly same. So lets just use am437x.dtb or something
like that.

Regards,
Santosh

