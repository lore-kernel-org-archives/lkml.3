Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946037AbaD3QlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:41:05 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:35820 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945935AbaD3QlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:41:02 -0400
Date: Wed, 30 Apr 2014 18:38:07 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] ARM: dts: kirkwood: add stdout-path property to
 all boards
Message-ID: <20140430163807.GA3082@lunn.ch>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1398862602-29595-4-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398862602-29595-4-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 02:56:30PM +0200, Sebastian Hesselbarth wrote:
> ePAPR allows to reference the device used for console output by
> stdout-path property. With node labels for Kirkwood UART0, now
> reference it on all Kirkwood boards that already have ttyS0 in
> their bootargs property.

Hi Sebastian

Could this be done in kirkwood.dtsi. I don't think we have any board
using ttyS1 for console, and if one does come along, it should be able
to override it.

   Andrew
 
> While at it, fix some whitespace issues on mplcec4's chosen node
> (there are more, but we only fix the chosen node now)
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/kirkwood-b3.dts                      | 1 +
>  arch/arm/boot/dts/kirkwood-cloudbox.dts                | 1 +
>  arch/arm/boot/dts/kirkwood-db.dtsi                     | 1 +
>  arch/arm/boot/dts/kirkwood-dns320.dts                  | 1 +
>  arch/arm/boot/dts/kirkwood-dns325.dts                  | 1 +
>  arch/arm/boot/dts/kirkwood-dockstar.dts                | 1 +
>  arch/arm/boot/dts/kirkwood-dreamplug.dts               | 1 +
>  arch/arm/boot/dts/kirkwood-ds109.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-ds110jv10.dts               | 1 +
>  arch/arm/boot/dts/kirkwood-ds111.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-ds112.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-ds209.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-ds210.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-ds212.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-ds212j.dts                  | 1 +
>  arch/arm/boot/dts/kirkwood-ds409.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-ds409slim.dts               | 1 +
>  arch/arm/boot/dts/kirkwood-ds411.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-ds411j.dts                  | 1 +
>  arch/arm/boot/dts/kirkwood-ds411slim.dts               | 1 +
>  arch/arm/boot/dts/kirkwood-goflexnet.dts               | 1 +
>  arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts    | 1 +
>  arch/arm/boot/dts/kirkwood-ib62x0.dts                  | 1 +
>  arch/arm/boot/dts/kirkwood-iconnect.dts                | 1 +
>  arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts          | 1 +
>  arch/arm/boot/dts/kirkwood-km_kirkwood.dts             | 1 +
>  arch/arm/boot/dts/kirkwood-laplug.dts                  | 1 +
>  arch/arm/boot/dts/kirkwood-lsxl.dtsi                   | 1 +
>  arch/arm/boot/dts/kirkwood-mplcec4.dts                 | 7 ++++---
>  arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts         | 1 +
>  arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts | 1 +
>  arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts | 1 +
>  arch/arm/boot/dts/kirkwood-ns2-common.dtsi             | 1 +
>  arch/arm/boot/dts/kirkwood-nsa310.dts                  | 1 +
>  arch/arm/boot/dts/kirkwood-nsa310a.dts                 | 1 +
>  arch/arm/boot/dts/kirkwood-nsa320.dts                  | 1 +
>  arch/arm/boot/dts/kirkwood-openblocks_a6.dts           | 1 +
>  arch/arm/boot/dts/kirkwood-openblocks_a7.dts           | 1 +
>  arch/arm/boot/dts/kirkwood-rd88f6192.dts               | 1 +
>  arch/arm/boot/dts/kirkwood-rd88f6281.dtsi              | 1 +
>  arch/arm/boot/dts/kirkwood-rs212.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-rs409.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-rs411.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi      | 1 +
>  arch/arm/boot/dts/kirkwood-t5325.dts                   | 1 +
>  arch/arm/boot/dts/kirkwood-topkick.dts                 | 1 +
>  arch/arm/boot/dts/kirkwood-ts219.dtsi                  | 1 +
>  47 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/kirkwood-b3.dts b/arch/arm/boot/dts/kirkwood-b3.dts
> index 40791053106b..86073f4f31ac 100644
> --- a/arch/arm/boot/dts/kirkwood-b3.dts
> +++ b/arch/arm/boot/dts/kirkwood-b3.dts
> @@ -30,6 +30,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-cloudbox.dts b/arch/arm/boot/dts/kirkwood-cloudbox.dts
> index 0e06fd3cee4d..61212692740e 100644
> --- a/arch/arm/boot/dts/kirkwood-cloudbox.dts
> +++ b/arch/arm/boot/dts/kirkwood-cloudbox.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-db.dtsi b/arch/arm/boot/dts/kirkwood-db.dtsi
> index 02d1225ef99f..22df970df2a1 100644
> --- a/arch/arm/boot/dts/kirkwood-db.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-db.dtsi
> @@ -22,6 +22,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-dns320.dts b/arch/arm/boot/dts/kirkwood-dns320.dts
> index bf7fe8ab88f4..3210daeb264c 100644
> --- a/arch/arm/boot/dts/kirkwood-dns320.dts
> +++ b/arch/arm/boot/dts/kirkwood-dns320.dts
> @@ -13,6 +13,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-leds {
> diff --git a/arch/arm/boot/dts/kirkwood-dns325.dts b/arch/arm/boot/dts/kirkwood-dns325.dts
> index cb9978c652f2..5e586ed04c58 100644
> --- a/arch/arm/boot/dts/kirkwood-dns325.dts
> +++ b/arch/arm/boot/dts/kirkwood-dns325.dts
> @@ -13,6 +13,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-leds {
> diff --git a/arch/arm/boot/dts/kirkwood-dockstar.dts b/arch/arm/boot/dts/kirkwood-dockstar.dts
> index f31312ebd0d6..d703f3eeef1c 100644
> --- a/arch/arm/boot/dts/kirkwood-dockstar.dts
> +++ b/arch/arm/boot/dts/kirkwood-dockstar.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk root=/dev/sda1 rootdelay=10";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-dreamplug.dts b/arch/arm/boot/dts/kirkwood-dreamplug.dts
> index ef3463e0ae19..8ed737e9aa2f 100644
> --- a/arch/arm/boot/dts/kirkwood-dreamplug.dts
> +++ b/arch/arm/boot/dts/kirkwood-dreamplug.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds109.dts b/arch/arm/boot/dts/kirkwood-ds109.dts
> index 772092c94ca3..d4bcc1c7f6b3 100644
> --- a/arch/arm/boot/dts/kirkwood-ds109.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds109.dts
> @@ -25,6 +25,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-150-32-35 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds110jv10.dts b/arch/arm/boot/dts/kirkwood-ds110jv10.dts
> index aabafbe0da4c..95bf83b91b4a 100644
> --- a/arch/arm/boot/dts/kirkwood-ds110jv10.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds110jv10.dts
> @@ -25,6 +25,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-150-32-35 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds111.dts b/arch/arm/boot/dts/kirkwood-ds111.dts
> index 16ec7fbab573..61f47fbe44d0 100644
> --- a/arch/arm/boot/dts/kirkwood-ds111.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds111.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-100-15-35-1 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds112.dts b/arch/arm/boot/dts/kirkwood-ds112.dts
> index cff1b2388765..bf4143c6cb8f 100644
> --- a/arch/arm/boot/dts/kirkwood-ds112.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds112.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-100-15-35-1 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds209.dts b/arch/arm/boot/dts/kirkwood-ds209.dts
> index 330411993d38..6d25093a9ac4 100644
> --- a/arch/arm/boot/dts/kirkwood-ds209.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds209.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-150-32-35 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds210.dts b/arch/arm/boot/dts/kirkwood-ds210.dts
> index 6052eaa37d4f..2f1933efcac1 100644
> --- a/arch/arm/boot/dts/kirkwood-ds210.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds210.dts
> @@ -26,6 +26,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-150-32-35 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds212.dts b/arch/arm/boot/dts/kirkwood-ds212.dts
> index 7f76cd30e84e..99afd462f956 100644
> --- a/arch/arm/boot/dts/kirkwood-ds212.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds212.dts
> @@ -27,6 +27,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-100-15-35-1 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds212j.dts b/arch/arm/boot/dts/kirkwood-ds212j.dts
> index 1f83a00f1f74..f5c4213fc67c 100644
> --- a/arch/arm/boot/dts/kirkwood-ds212j.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds212j.dts
> @@ -25,6 +25,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-100-32-35 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds409.dts b/arch/arm/boot/dts/kirkwood-ds409.dts
> index 0a573add44a2..e80a962ebba0 100644
> --- a/arch/arm/boot/dts/kirkwood-ds409.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds409.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-150-15-18 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds409slim.dts b/arch/arm/boot/dts/kirkwood-ds409slim.dts
> index 1848a6245fd3..cae5af4b88b5 100644
> --- a/arch/arm/boot/dts/kirkwood-ds409slim.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds409slim.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-150-32-35 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds411.dts b/arch/arm/boot/dts/kirkwood-ds411.dts
> index a1737b4311c6..623cd4a37d71 100644
> --- a/arch/arm/boot/dts/kirkwood-ds411.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds411.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-100-15-35-1 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds411j.dts b/arch/arm/boot/dts/kirkwood-ds411j.dts
> index 0cde914eceae..3348e330f074 100644
> --- a/arch/arm/boot/dts/kirkwood-ds411j.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds411j.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-150-15-18 {
> diff --git a/arch/arm/boot/dts/kirkwood-ds411slim.dts b/arch/arm/boot/dts/kirkwood-ds411slim.dts
> index aef0cadc2c78..a0a1fad8b4de 100644
> --- a/arch/arm/boot/dts/kirkwood-ds411slim.dts
> +++ b/arch/arm/boot/dts/kirkwood-ds411slim.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-100-15-35-1 {
> diff --git a/arch/arm/boot/dts/kirkwood-goflexnet.dts b/arch/arm/boot/dts/kirkwood-goflexnet.dts
> index eb9329420107..5e39cc3ca95e 100644
> --- a/arch/arm/boot/dts/kirkwood-goflexnet.dts
> +++ b/arch/arm/boot/dts/kirkwood-goflexnet.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk root=/dev/sda1 rootdelay=10";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
> index 2d51fce74a5a..db183455ff34 100644
> --- a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
> +++ b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-ib62x0.dts b/arch/arm/boot/dts/kirkwood-ib62x0.dts
> index a1add3f215e3..810818b2bff6 100644
> --- a/arch/arm/boot/dts/kirkwood-ib62x0.dts
> +++ b/arch/arm/boot/dts/kirkwood-ib62x0.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-iconnect.dts b/arch/arm/boot/dts/kirkwood-iconnect.dts
> index 8d8c80e3656d..7c4cd7e7535b 100644
> --- a/arch/arm/boot/dts/kirkwood-iconnect.dts
> +++ b/arch/arm/boot/dts/kirkwood-iconnect.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  		linux,initrd-start = <0x4500040>;
>  		linux,initrd-end   = <0x4800000>;
>  	};
> diff --git a/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts b/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
> index 59e7a5adeedb..9a8d40a17938 100644
> --- a/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
> +++ b/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-km_kirkwood.dts b/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
> index 04a1e44541b3..2213a20e7871 100644
> --- a/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
> +++ b/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-laplug.dts b/arch/arm/boot/dts/kirkwood-laplug.dts
> index c9e82eff9bf2..6e83b13fc26a 100644
> --- a/arch/arm/boot/dts/kirkwood-laplug.dts
> +++ b/arch/arm/boot/dts/kirkwood-laplug.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-lsxl.dtsi b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
> index 1656653d339b..ed3cdfbb45bb 100644
> --- a/arch/arm/boot/dts/kirkwood-lsxl.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
> @@ -4,6 +4,7 @@
>  / {
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-mplcec4.dts b/arch/arm/boot/dts/kirkwood-mplcec4.dts
> index 73722c067501..b23abfe08d2f 100644
> --- a/arch/arm/boot/dts/kirkwood-mplcec4.dts
> +++ b/arch/arm/boot/dts/kirkwood-mplcec4.dts
> @@ -12,9 +12,10 @@
>                  reg = <0x00000000 0x20000000>;
>          };
>  
> -        chosen {
> -                bootargs = "console=ttyS0,115200n8 earlyprintk";
> -        };
> +	chosen {
> +		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
> +	};
>  
>  	mbus {
>  		pcie-controller {
> diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
> index 4bf358c28be2..9c48e827e34e 100644
> --- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
> +++ b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
> @@ -28,6 +28,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
> index 4838478019cc..b29cab304fd0 100644
> --- a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
> +++ b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
> @@ -25,6 +25,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts b/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
> index 7c8a0d9d8d1f..4ef494231b78 100644
> --- a/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
> +++ b/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
> @@ -25,6 +25,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
> index 743152f31a81..da8891bbeec8 100644
> --- a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
> @@ -4,6 +4,7 @@
>  / {
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-nsa310.dts b/arch/arm/boot/dts/kirkwood-nsa310.dts
> index 989846ac6577..cd68210b9f11 100644
> --- a/arch/arm/boot/dts/kirkwood-nsa310.dts
> +++ b/arch/arm/boot/dts/kirkwood-nsa310.dts
> @@ -12,6 +12,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-nsa310a.dts b/arch/arm/boot/dts/kirkwood-nsa310a.dts
> index d0a602578f5b..8fd72d49e43f 100644
> --- a/arch/arm/boot/dts/kirkwood-nsa310a.dts
> +++ b/arch/arm/boot/dts/kirkwood-nsa310a.dts
> @@ -17,6 +17,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-nsa320.dts b/arch/arm/boot/dts/kirkwood-nsa320.dts
> index fc20baf0eade..817eaf02a346 100644
> --- a/arch/arm/boot/dts/kirkwood-nsa320.dts
> +++ b/arch/arm/boot/dts/kirkwood-nsa320.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> index b88da9392c32..557b824f9c43 100644
> --- a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> +++ b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
> index b2f7cae06839..b1f5e1180803 100644
> --- a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
> +++ b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
> @@ -26,6 +26,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-rd88f6192.dts b/arch/arm/boot/dts/kirkwood-rd88f6192.dts
> index e9dd85049297..8df800757175 100644
> --- a/arch/arm/boot/dts/kirkwood-rd88f6192.dts
> +++ b/arch/arm/boot/dts/kirkwood-rd88f6192.dts
> @@ -26,6 +26,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi b/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
> index d6368c39102e..c573c204dbdb 100644
> --- a/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
> @@ -22,6 +22,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-rs212.dts b/arch/arm/boot/dts/kirkwood-rs212.dts
> index 93ec3d00c6ab..3b19f1fd4cac 100644
> --- a/arch/arm/boot/dts/kirkwood-rs212.dts
> +++ b/arch/arm/boot/dts/kirkwood-rs212.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-100-15-35-3 {
> diff --git a/arch/arm/boot/dts/kirkwood-rs409.dts b/arch/arm/boot/dts/kirkwood-rs409.dts
> index 311df4e5aa28..921ca49e85a4 100644
> --- a/arch/arm/boot/dts/kirkwood-rs409.dts
> +++ b/arch/arm/boot/dts/kirkwood-rs409.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-150-15-18 {
> diff --git a/arch/arm/boot/dts/kirkwood-rs411.dts b/arch/arm/boot/dts/kirkwood-rs411.dts
> index f90da850bb31..02852b0c809f 100644
> --- a/arch/arm/boot/dts/kirkwood-rs411.dts
> +++ b/arch/arm/boot/dts/kirkwood-rs411.dts
> @@ -24,6 +24,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	gpio-fan-100-15-35-3 {
> diff --git a/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi b/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
> index 1ff848d570a9..bd01d306a754 100644
> --- a/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
> @@ -17,6 +17,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-t5325.dts b/arch/arm/boot/dts/kirkwood-t5325.dts
> index 7d1c7677a18f..df53176c9354 100644
> --- a/arch/arm/boot/dts/kirkwood-t5325.dts
> +++ b/arch/arm/boot/dts/kirkwood-t5325.dts
> @@ -27,6 +27,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> diff --git a/arch/arm/boot/dts/kirkwood-topkick.dts b/arch/arm/boot/dts/kirkwood-topkick.dts
> index 5fc817c2cb87..a85025ef4c52 100644
> --- a/arch/arm/boot/dts/kirkwood-topkick.dts
> +++ b/arch/arm/boot/dts/kirkwood-topkick.dts
> @@ -14,6 +14,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8 earlyprintk";
> +		stdout-path = &uart0;
>  	};
>  
>  	ocp@f1000000 {
> diff --git a/arch/arm/boot/dts/kirkwood-ts219.dtsi b/arch/arm/boot/dts/kirkwood-ts219.dtsi
> index 911f3a8cee23..8f2226b8bd3d 100644
> --- a/arch/arm/boot/dts/kirkwood-ts219.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-ts219.dtsi
> @@ -9,6 +9,7 @@
>  
>  	chosen {
>  		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
>  	};
>  
>  	mbus {
> -- 
> 1.9.1
> 
