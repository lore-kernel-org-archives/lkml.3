Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaIIADn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:03:43 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64633 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaIIADk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:03:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19vHq1ViClR36re2XVV/TFn
Date: Mon, 8 Sep 2014 17:03:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: board-generic: add support for AM57xx family
Message-ID: <20140909000334.GV3238@atomide.com>
References: <1408388875-7360-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408388875-7360-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140818 12:10]:
> AM57xx processor family are variants of DRA7 family of processors and
> targetted at industrial and non-automotive applications.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Applying into omap-for-v3.18/dt thanks.

Tony

> ---
> 
> NOTE: there is no discrenable features yet defined in register set at
> this point in time.
> 
> Tested on AM5728 compatible platform and based on v3.17-rc1
> 
>  .../devicetree/bindings/arm/omap/omap.txt          |   12 ++++++++++++
>  arch/arm/mach-omap2/board-generic.c                |    4 ++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
> index 0edc903..ddd9bcd 100644
> --- a/Documentation/devicetree/bindings/arm/omap/omap.txt
> +++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
> @@ -85,6 +85,18 @@ SoCs:
>  - DRA722
>    compatible = "ti,dra722", "ti,dra72", "ti,dra7"
>  
> +- AM5728
> +  compatible = "ti,am5728", "ti,dra742", "ti,dra74", "ti,dra7"
> +
> +- AM5726
> +  compatible = "ti,am5726", "ti,dra742", "ti,dra74", "ti,dra7"
> +
> +- AM5718
> +  compatible = "ti,am5718", "ti,dra722", "ti,dra72", "ti,dra7"
> +
> +- AM5716
> +  compatible = "ti,am5716", "ti,dra722", "ti,dra72", "ti,dra7"
> +
>  - AM4372
>    compatible = "ti,am4372", "ti,am43"
>  
> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index 9480997..bdb5194 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -241,6 +241,8 @@ MACHINE_END
>  
>  #ifdef CONFIG_SOC_DRA7XX
>  static const char *dra74x_boards_compat[] __initconst = {
> +	"ti,am5728",
> +	"ti,am5726",
>  	"ti,dra742",
>  	"ti,dra7",
>  	NULL,
> @@ -260,6 +262,8 @@ DT_MACHINE_START(DRA74X_DT, "Generic DRA74X (Flattened Device Tree)")
>  MACHINE_END
>  
>  static const char *dra72x_boards_compat[] __initconst = {
> +	"ti,am5718",
> +	"ti,am5716",
>  	"ti,dra722",
>  	NULL,
>  };
> -- 
> 1.7.9.5
> 
