Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaAOMDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:03:40 -0500
Received: from 16.mo6.mail-out.ovh.net ([87.98.139.208]:55459 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751286AbaAOMDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:03:39 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jan 2014 07:03:39 EST
Date: Wed, 15 Jan 2014 12:25:28 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 09/12] at91: dt: sam9261: Pinmux DT entries for the
 SMC/EBI interface
Message-ID: <20140115112528.GR14627@ns203013.ovh.net>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
 <1389270709-32662-10-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389270709-32662-10-git-send-email-jjhiblot@traphandler.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 8168685300172303193
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:31 Thu 09 Jan     , Jean-Jacques Hiblot wrote:
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  arch/arm/boot/dts/at91sam9261.dtsi | 54 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
> index cd219b9..695d5d2 100644
> --- a/arch/arm/boot/dts/at91sam9261.dtsi
> +++ b/arch/arm/boot/dts/at91sam9261.dtsi
> @@ -317,6 +317,60 @@
>  							 >;
>  					};
>  				};
> +				smc {
> +					pinctrl_smc_nwait: smc_nwait-0 {
> +						atmel,pins = <AT91_PIOC 2 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_a23_a25: smc_a23_a25-0 {
use better name this is not clear
> +						atmel,pins =
> +							<AT91_PIOA 30 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOA 31 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOC 3  AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_d16_d31: smc_d16_d31-0 {
> +						atmel,pins =
> +							<AT91_PIOC 16 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 17 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 18 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 19 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 20 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 21 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 22 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 23 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 24 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 25 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 26 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 27 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 28 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 29 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 30 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOC 31 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_ncs4: smc_ncs4-0 {
> +						atmel,pins = <AT91_PIOC 4 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_ncs5: smc_ncs5-0 {
> +						atmel,pins = <AT91_PIOC 5 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_nandoe: smc_nandoe-0 {
> +						atmel,pins = <AT91_PIOC 0 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_ncs6: smc_ncs6-0 {
> +						atmel,pins = <AT91_PIOC 0 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_nandwe: smc_nandwe-0 {
> +						atmel,pins = <AT91_PIOC 1 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_ncs7: smc_ncs7-0 {
> +						atmel,pins = <AT91_PIOC 1 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_cfce1: smc_cfce1-0 {
> +						atmel,pins = <AT91_PIOC 6 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_smc_cfce2: smc_cfce2-0 {
> +						atmel,pins = <AT91_PIOC 7 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +				};
>  				pioA: gpio@fffff400 {
>  					compatible = "atmel,at91rm9200-gpio";
>  					reg = <0xfffff400 0x200>;
> -- 
> 1.8.5.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
