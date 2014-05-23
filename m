Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaEWMJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:09:23 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:60758 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaEWMJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:09:21 -0400
Date: Fri, 23 May 2014 08:09:16 -0400
From: Matt Porter <mporter@linaro.org>
To: Devicetree List <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/4] ARM: dts: bcm590xx: add support for GPLDO and
 VBUS regulators
Message-ID: <20140523120916.GY32082@beef>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-5-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398295293-11033-5-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:21:33PM -0400, Matt Porter wrote:
> Adds additional nodes to support GPLDO1-6 and VBUS regulators which
> are now supported in the bcm590xx regulator driver.

Applied to mach-bcm for-3.16/dt

>  arch/arm/boot/dts/bcm59056.dtsi | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/bcm59056.dtsi b/arch/arm/boot/dts/bcm59056.dtsi
> index dfadaaa..066adfb 100644
> --- a/arch/arm/boot/dts/bcm59056.dtsi
> +++ b/arch/arm/boot/dts/bcm59056.dtsi
> @@ -70,5 +70,26 @@
>  
>  		vsr_reg: vsr {
>  		};
> +
> +		gpldo1_reg: gpldo1 {
> +		};
> +
> +		gpldo2_reg: gpldo2 {
> +		};
> +
> +		gpldo3_reg: gpldo3 {
> +		};
> +
> +		gpldo4_reg: gpldo4 {
> +		};
> +
> +		gpldo5_reg: gpldo5 {
> +		};
> +
> +		gpldo6_reg: gpldo6 {
> +		};
> +
> +		vbus_reg: vbus {
> +		};
>  	};
>  };
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
