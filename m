Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161594Ab3DEGiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:38:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:41924 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3DEGit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:38:49 -0400
X-Auth-Info: ZszFglAe+ZeJhislIk/SALhPyobm5Xha5dG1uhxSktY=
From: Marek Vasut <marex@denx.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] ARM: dts: imx23-olinuxino: Set the sdcard as non-removable
Date: Fri, 5 Apr 2013 08:38:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux@arm.linux.org.uk, shawn.guo@linaro.org, fabio.estevam@freescale.com,
        otavio@ossystems.com.br, maxime.ripard@free-electrons.com,
        f.koliqi@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1365135413-31493-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1365135413-31493-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304050838.42571.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Pereira da Silva,

> The imx23-olinuxino sdcard doesn't support card detect.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
>  arch/arm/boot/dts/imx23-olinuxino.dts |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/imx23-olinuxino.dts
> b/arch/arm/boot/dts/imx23-olinuxino.dts index e7484e4..03f55c2 100644
> --- a/arch/arm/boot/dts/imx23-olinuxino.dts
> +++ b/arch/arm/boot/dts/imx23-olinuxino.dts
> @@ -29,6 +29,7 @@
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&mmc0_4bit_pins_a 
&mmc0_pins_fixup>;
>  				bus-width = <4>;
> +				non-removable;
>  				status = "okay";
>  			};

The card on mx23 olinuxino seems perfectly removable to me ... on all possible 
models and even prototypes and hybrids too ;-)

Best regards,
Marek Vasut
