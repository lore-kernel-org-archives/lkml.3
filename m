Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3EIAQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 20:16:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35446 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3EIAQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 20:16:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19iSmIsQ3WKgQcz+6dnGvA0
Date: Wed, 8 May 2013 17:16:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: linux-mtd@lists.infradead.org, b-cousson@ti.com, linux@arm.linux.org.uk,
        "Philip, Avinash" <avinashphilip@ti.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, hvaibhav@ti.com,
        zonque@gmail.com, jacmet@sunsite.dk
Subject: Re: [PATCH v3,2/3] ARM: dts: AM33XX: Add GPMC node
Message-ID: <20130509001606.GZ32546@atomide.com>
References: <2645efefa3d36388ff1d4b64255d880b6587770f.1359007746.git.avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2645efefa3d36388ff1d4b64255d880b6587770f.1359007746.git.avinashphilip@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gupta, Pekon <pekon@ti.com> [130502 02:49]:
> From: "Philip, Avinash" <avinashphilip@ti.com>
> 
> Add GPMC data node to AM33XX device tree file.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
> Signed-off-by: Pekon Gupta <pekon@ti.com>

Thanks adding into omap-for-v3.10/dt-fixes.

Tony
 
> ---
> Changes in v2:
> 	- Change number of chip select to 7
> 
>  arch/arm/boot/dts/am33xx.dtsi |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 24fc835..1048795 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -407,5 +407,17 @@
>  			ti,hwmods = "elm";
>  			status = "disabled";
>  		};
> +
> +		gpmc: gpmc@50000000 {
> +			compatible = "ti,am3352-gpmc";
> +			ti,hwmods = "gpmc";
> +			reg = <0x50000000 0x2000>;
> +			interrupts = <100>;
> +			num-cs = <7>;
> +			num-waitpins = <2>;
> +			#address-cells = <2>;
> +			#size-cells = <1>;
> +			status = "disabled";
> +		};
>  	};
>  };
