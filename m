Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3ARNR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:17:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37348 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3ARNR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:17:57 -0500
Message-ID: <1358515063.3873.31.camel@coredoba.hi.pengutronix.de>
Subject: Re: [PATCH 2/3] ARM: dts: AM33XX: Add GPMC node
From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To: Philip Avinash <avinashphilip@ti.com>
Cc: b-cousson@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, zonque@gmail.com
Date: Fri, 18 Jan 2013 14:17:43 +0100
In-Reply-To: <1358491295-4022-3-git-send-email-avinashphilip@ti.com>
References: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
	 <1358491295-4022-3-git-send-email-avinashphilip@ti.com>
Organization: Pengutronix
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:99ff:fe56:8d7
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-18 at 12:11 +0530, Philip Avinash wrote:
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index eaef5e7..f4209d8 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -393,5 +393,17 @@
>  			ti,hwmods = "elm";
>  			status = "disabled";
>  		};
> +
> +		gpmc: gpmc@50000000 {
> +			compatible = "ti,am3352-gpmc";
> +			ti,hwmods = "gpmc";
> +			reg = <0x50000000 0x2000>;
> +			interrupts = <100>;
> +			num-cs = <8>;

According to the AM335x TRM (SPRUH73G) page 254 we have GPMC_CSn[6:0],
so num-cs should probably be <7>.

> +			num-waitpins = <2>;
> +			#address-cells = <2>;
> +			#size-cells = <1>;
> +			status = "disabled";
> +		};
>  	};
>  };

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

