Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3HMPm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:42:57 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45287 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab3HMPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:42:54 -0400
Date: Tue, 13 Aug 2013 16:42:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 16/22] ARM: dts: Remove '0x's from OMAP3430 SDP DTS file
Message-ID: <20130813154248.GD15278@lee--X1>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-16-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374490361-25769-16-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony, Benoit,

Poke

On Mon, 22 Jul 2013, Lee Jones wrote:

> Cc: Benoît Cousson <b-cousson@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-omap@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/omap3430-sdp.dts | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3430-sdp.dts b/arch/arm/boot/dts/omap3430-sdp.dts
> index e2249bc..281914e 100644
> --- a/arch/arm/boot/dts/omap3430-sdp.dts
> +++ b/arch/arm/boot/dts/omap3430-sdp.dts
> @@ -84,15 +84,15 @@
>  			label = "bootloader-nor";
>  			reg = <0 0x40000>;
>  		};
> -		partition@0x40000 {
> +		partition@40000 {
>  			label = "params-nor";
>  			reg = <0x40000 0x40000>;
>  		};
> -		partition@0x80000 {
> +		partition@80000 {
>  			label = "kernel-nor";
>  			reg = <0x80000 0x200000>;
>  		};
> -		partition@0x280000 {
> +		partition@280000 {
>  			label = "filesystem-nor";
>  			reg = <0x240000 0x7d80000>;
>  		};
> @@ -125,19 +125,19 @@
>  			label = "xloader-nand";
>  			reg = <0 0x80000>;
>  		};
> -		partition@0x80000 {
> +		partition@80000 {
>  			label = "bootloader-nand";
>  			reg = <0x80000 0x140000>;
>  		};
> -		partition@0x1c0000 {
> +		partition@1c0000 {
>  			label = "params-nand";
>  			reg = <0x1c0000 0xc0000>;
>  		};
> -		partition@0x280000 {
> +		partition@280000 {
>  			label = "kernel-nand";
>  			reg = <0x280000 0x500000>;
>  		};
> -		partition@0x780000 {
> +		partition@780000 {
>  			label = "filesystem-nand";
>  			reg = <0x780000 0x7880000>;
>  		};
> @@ -170,19 +170,19 @@
>  			label = "xloader-onenand";
>  			reg = <0 0x80000>;
>  		};
> -		partition@0x80000 {
> +		partition@80000 {
>  			label = "bootloader-onenand";
>  			reg = <0x80000 0x40000>;
>  		};
> -		partition@0xc0000 {
> +		partition@c0000 {
>  			label = "params-onenand";
>  			reg = <0xc0000 0x20000>;
>  		};
> -		partition@0xe0000 {
> +		partition@e0000 {
>  			label = "kernel-onenand";
>  			reg = <0xe0000 0x200000>;
>  		};
> -		partition@0x2e0000 {
> +		partition@2e0000 {
>  			label = "filesystem-onenand";
>  			reg = <0x2e0000 0xfd20000>;
>  		};

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
