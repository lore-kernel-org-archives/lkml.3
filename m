Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3HMPoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:44:10 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:47753 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758383Ab3HMPoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:44:08 -0400
Date: Tue, 13 Aug 2013 16:44:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 13/22] ARM: dts: Remove '0x's from OMAP3 IGEP0020 DTS file
Message-ID: <20130813154400.GG15278@lee--X1>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-13-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374490361-25769-13-git-send-email-lee.jones@linaro.org>
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
>  arch/arm/boot/dts/omap3-igep0020.dts | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-igep0020.dts b/arch/arm/boot/dts/omap3-igep0020.dts
> index e8c4828..f7a8122 100644
> --- a/arch/arm/boot/dts/omap3-igep0020.dts
> +++ b/arch/arm/boot/dts/omap3-igep0020.dts
> @@ -99,19 +99,19 @@
>  			label = "SPL";
>  			reg = <0 0x100000>;
>  		};
> -		partition@0x80000 {
> +		partition@80000 {
>  			label = "U-Boot";
>  			reg = <0x100000 0x180000>;
>  		};
> -		partition@0x1c0000 {
> +		partition@1c0000 {
>  			label = "Environment";
>  			reg = <0x280000 0x100000>;
>  		};
> -		partition@0x280000 {
> +		partition@280000 {
>  			label = "Kernel";
>  			reg = <0x380000 0x300000>;
>  		};
> -		partition@0x780000 {
> +		partition@780000 {
>  			label = "Filesystem";
>  			reg = <0x680000 0x1f980000>;
>  		};

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
