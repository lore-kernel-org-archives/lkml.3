Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3JQQDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:03:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:4836 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab3JQQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:03:22 -0400
Message-ID: <52600A45.6070508@atmel.com>
Date: Thu, 17 Oct 2013 18:03:17 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Mike Turquette" <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v4 10/17] clk: at91: add peripheral clk macros for peripheral
 clk dt bindings
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com> <1381485180-13796-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1381485180-13796-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 11:53, Boris BREZILLON :
> This patch adds the peripheral divisors macros (for sam9x5 compatible IPs)
> which will be used by peripheral clk dt definitions.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   include/dt-bindings/clk/at91.h |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/include/dt-bindings/clk/at91.h b/include/dt-bindings/clk/at91.h
> index 0b4cb99..a3b07ca 100644
> --- a/include/dt-bindings/clk/at91.h
> +++ b/include/dt-bindings/clk/at91.h
> @@ -19,4 +19,10 @@
>   #define AT91_PMC_MOSCRCS	17		/* Main On-Chip RC */
>   #define AT91_PMC_CFDEV		18		/* Clock Failure Detector Event */
>
> +/* sam9x5 peripheral divisors */
> +#define AT91SAM9X5_PERIPH_CLK_DIV1	0
> +#define AT91SAM9X5_PERIPH_CLK_DIV2	1
> +#define AT91SAM9X5_PERIPH_CLK_DIV4	2
> +#define AT91SAM9X5_PERIPH_CLK_DIV8	3
> +
>   #endif
>


-- 
Nicolas Ferre
