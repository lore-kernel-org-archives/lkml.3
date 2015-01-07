Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbbAGOjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:39:08 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49350 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbbAGOjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:39:05 -0500
Message-ID: <54AD4506.6000304@gmail.com>
Date: Wed, 07 Jan 2015 15:39:02 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Jisheng Zhang <jszhang@marvell.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, antoine.tenart@free-electrons.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ARM: dts: berlin: add pmu node for BG2Q and BG2CD
References: <1419584281-4811-1-git-send-email-jszhang@marvell.com> <1419584281-4811-2-git-send-email-jszhang@marvell.com>
In-Reply-To: <1419584281-4811-2-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.12.2014 09:57, Jisheng Zhang wrote:
> This patch adds the pmu node, enabling the PMU unit on Marvell BG2Q and
> BG2CD SoCs.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Applied to berlin/dt.

Thanks!

> ---
>   arch/arm/boot/dts/berlin2cd.dtsi | 5 +++++
>   arch/arm/boot/dts/berlin2q.dtsi  | 8 ++++++++
>   2 files changed, 13 insertions(+)
>
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index 230df3b..a318bc3 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -45,6 +45,11 @@
>
>   		ranges = <0 0xf7000000 0x1000000>;
>
> +		pmu {
> +			compatible = "arm,cortex-a9-pmu";
> +			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
>   		sdhci0: sdhci@ab0000 {
>   			compatible = "mrvl,pxav3-mmc";
>   			reg = <0xab0000 0x200>;
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 35253c9..933dcbb 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -63,6 +63,14 @@
>   		ranges = <0 0xf7000000 0x1000000>;
>   		interrupt-parent = <&gic>;
>
> +		pmu {
> +			compatible = "arm,cortex-a9-pmu";
> +			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
>   		sdhci0: sdhci@ab0000 {
>   			compatible = "mrvl,pxav3-mmc";
>   			reg = <0xab0000 0x200>;
>

