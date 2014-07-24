Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaGXWcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:32:16 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37852 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaGXWcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:32:15 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, Sonny Rao <sonnyrao@chromium.org>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Build dtbs for Rockchip boards
Date: Fri, 25 Jul 2014 00:33:24 +0200
Message-ID: <7536612.LCojB7a6aY@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1406240270-13278-1-git-send-email-dianders@chromium.org>
References: <1406240270-13278-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Juli 2014, 15:17:50 schrieb Doug Anderson:
> This allows the "make dtbs" target to work.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I'll add it to my rk3288-branch


Thanks
Heiko

> ---
> This is built upon (ARM: dts: add rk3288 evaluation board) at
> <https://patchwork.kernel.org/patch/4579541/>, which won't actually
> build without the bindings that just landed in today's clk-next.
> 
>  arch/arm/boot/dts/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 82f498b..026f61d 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -341,6 +341,11 @@ dtb-$(CONFIG_ARCH_QCOM) += \
>  	qcom-apq8084-mtp.dtb \
>  	qcom-msm8660-surf.dtb \
>  	qcom-msm8960-cdp.dtb
> +dtb-$(CONFIG_ARCH_ROCKCHIP) += \
> +	rk3066a-bqcurie2.dtb \
> +	rk3188-radxarock.dtb \
> +	rk3288-evb-act8846.dtb \
> +	rk3288-evb-rk808.dtb
>  dtb-$(CONFIG_ARCH_S3C24XX) += s3c2416-smdk2416.dtb
>  dtb-$(CONFIG_ARCH_S3C64XX) += s3c6410-mini6410.dtb \
>  	s3c6410-smdk6410.dtb

