Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbbA0XBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:01:41 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47555 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbbA0XBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:01:39 -0500
Date: Tue, 27 Jan 2015 15:01:41 -0800
From: Olof Johansson <olof@lixom.net>
To: Baruch Siach <baruch@tkos.co.il>
Cc: arm@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 3/4] ARM: digicolor: add minimal device tree
 description
Message-ID: <20150127230141.GA11263@quad.lixom.net>
References: <cover.1421219953.git.baruch@tkos.co.il>
 <474d0849bb30ab4ec323fa4c1bc67b30b31d3884.1421219953.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474d0849bb30ab4ec323fa4c1bc67b30b31d3884.1421219953.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 14, 2015 at 10:40:32AM +0200, Baruch Siach wrote:
> cx92755.dtsi describes CX92755 on chip peripherals. conexant_equinox.dts
> describes the Equinox evaluation board for the CX92755 SoC.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  arch/arm/boot/dts/Makefile             |   1 +
>  arch/arm/boot/dts/conexant_equinox.dts |  74 +++++++++++++++++++++++
>  arch/arm/boot/dts/cx92755.dtsi         | 107 +++++++++++++++++++++++++++++++++
>  3 files changed, 182 insertions(+)
>  create mode 100644 arch/arm/boot/dts/conexant_equinox.dts
>  create mode 100644 arch/arm/boot/dts/cx92755.dtsi
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 91bd5bd62857..fbeb65eaddda 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -75,6 +75,7 @@ dtb-$(CONFIG_ARCH_BRCMSTB) += \
>  	bcm7445-bcm97445svmb.dtb
>  dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
>  	da850-evm.dtb
> +dtb-$(CONFIG_ARCH_DIGICOLOR) += conexant_equinox.dtb
>  dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
>  dtb-$(CONFIG_ARCH_EXYNOS) += exynos3250-monk.dtb \
>  	exynos3250-rinato.dtb \
> diff --git a/arch/arm/boot/dts/conexant_equinox.dts b/arch/arm/boot/dts/conexant_equinox.dts
> new file mode 100644
> index 000000000000..f33bf5635d47
> --- /dev/null
> +++ b/arch/arm/boot/dts/conexant_equinox.dts

To segment the namespace a bit, we ask that you prefix your dts files with the
platform. What would be a suitable prefix here? conexant? digicolor?


-Olof
