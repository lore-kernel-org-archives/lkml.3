Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3KTPEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:04:39 -0500
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:41793 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751558Ab3KTPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:04:37 -0500
Date: Wed, 20 Nov 2013 15:56:09 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/9] ARM: at91/dt: add rm9200 spi0 chip select pins
 definitions
Message-ID: <20131120145609.GC14627@ns203013.ovh.net>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
 <1377687742-10618-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377687742-10618-1-git-send-email-b.brezillon@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 14784191676774853497
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:02 Wed 28 Aug     , Boris BREZILLON wrote:
> Add spi0 cs pinctrl pins definitions.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  arch/arm/boot/dts/at91rm9200.dtsi |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
> index f770655..69b76c7 100644
> --- a/arch/arm/boot/dts/at91rm9200.dtsi
> +++ b/arch/arm/boot/dts/at91rm9200.dtsi
> @@ -486,6 +486,26 @@
>  							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A SPI0_MOSI pin */
>  							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA2 periph A SPI0_SPCK pin */
>  					};
> +
> +					pinctrl_spi0_cs0: spi0_cs0-0 {
> +						atmel,pins =
> +							<AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA3 periph A SPI0_NPCS0 pin */
> +					};
> +
> +					pinctrl_spi0_cs1: spi0_cs1-0 {
> +						atmel,pins =
> +							<AT91_PIOA 4 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA4 GPIO SPI0_NPCS1 pin */
> +					};
> +
> +					pinctrl_spi0_cs2: spi0_cs2-0 {
> +						atmel,pins =
> +							<AT91_PIOA 5 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA5 GPIO SPI0_NPCS2 pin */
> +					};
> +
> +					pinctrl_spi0_cs3: spi0_cs3-0 {
> +						atmel,pins =
> +							<AT91_PIOA 6 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA6 GPIO SPI0_NPCS3 pin */
> +					};
nack the pin are not multidrive there is only one master

Best Regards,
J.
>  				};
>  
>  				pioA: gpio@fffff400 {
> -- 
> 1.7.9.5
> 
