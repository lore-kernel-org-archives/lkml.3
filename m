Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaJKSYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:24:45 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56284 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaJKSYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:24:44 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: rockchip: enable DMA on SPI for rk3066 and rk3188
Date: Sat, 11 Oct 2014 20:24:27 +0200
Message-ID: <4669230.PsEI42KPZh@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412928253-5119-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1412928253-5119-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julien,

Am Freitag, 10. Oktober 2014, 10:04:13 schrieb Julien CHAUVEAU:
> According to the RK3066 and RK3188 TRM, the two SPI controllers support DMA
> handshake interface. Add the DMA properties so they can be used when needed.
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>

added the patch to a temporary branch for 3.19
(on github and will move to kernel.org once 3.18-rc1 is released)


Heiko

> ---
>  arch/arm/boot/dts/rk3xxx.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
> index 499468d..9ba92de 100644
> --- a/arch/arm/boot/dts/rk3xxx.dtsi
> +++ b/arch/arm/boot/dts/rk3xxx.dtsi
> @@ -367,6 +367,8 @@
>  		reg = <0x20070000 0x1000>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> +		dmas = <&dmac2 10>, <&dmac2 11>;
> +		dma-names = "tx", "rx";
>  		status = "disabled";
>  	};
> 
> @@ -378,6 +380,8 @@
>  		reg = <0x20074000 0x1000>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> +		dmas = <&dmac2 12>, <&dmac2 13>;
> +		dma-names = "tx", "rx";
>  		status = "disabled";
>  	};
>  };

