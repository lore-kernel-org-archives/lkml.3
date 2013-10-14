Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3JNTgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:36:03 -0400
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:33232 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3JNTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:36:01 -0400
Date: Mon, 14 Oct 2013 19:09:51 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, ebenard@eukrea.com,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: at91/dt/trivial: before sama5d3, Atmel MPU were
 using at91 prefix
Message-ID: <20131014170951.GJ11420@ns203013.ovh.net>
References: <ba9872c3bb29c9a06f06caa8e0b4528329f07675.1381769174.git.nicolas.ferre@atmel.com>
 <a7f43a96aaf83c3348dc631c71c54729f9d0e9e0.1381769174.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7f43a96aaf83c3348dc631c71c54729f9d0e9e0.1381769174.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 2728055474426719084
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:46 Mon 14 Oct     , Nicolas Ferre wrote:
> Change the sha/aes/tdes compatibility string to match common
> case for the at91sam9g45 family which is to keep the at91 prefix.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/boot/dts/sama5d3.dtsi | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index b2aabff..99bd4a6 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -342,19 +342,19 @@
>  			};
>  
>  			sha@f8034000 {
> -				compatible = "atmel,sam9g46-sha";
> +				compatible = "atmel,at91sam9g46-sha";
>  				reg = <0xf8034000 0x100>;
>  				interrupts = <42 IRQ_TYPE_LEVEL_HIGH 0>;
>  			};
>  
>  			aes@f8038000 {
> -				compatible = "atmel,sam9g46-aes";
> +				compatible = "atmel,at91sam9g46-aes";
>  				reg = <0xf8038000 0x100>;
>  				interrupts = <43 IRQ_TYPE_LEVEL_HIGH 0>;
>  			};
>  
>  			tdes@f803c000 {
> -				compatible = "atmel,sam9g46-tdes";
> +				compatible = "atmel,at91sam9g46-tdes";
>  				reg = <0xf803c000 0x100>;
>  				interrupts = <44 IRQ_TYPE_LEVEL_HIGH 0>;
you keep the previous compatible in the driver too for backword compatiblity

Best Regards,
J.
>  			};
> -- 
> 1.8.2.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
