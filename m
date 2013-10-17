Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3JQPrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:47:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:51822 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3JQPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:47:50 -0400
Message-ID: <526006A0.1080704@atmel.com>
Date: Thu, 17 Oct 2013 17:47:44 +0200
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
Subject: Re: [PATCH v4 04/17] clk: at91: add PMC macro file for dt definitions
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com> <1381480885-11994-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1381480885-11994-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 10:41, Boris BREZILLON :
> This patch adds a new macro file for PMC macros.
>
> This macro file includes the definitions of SR (status register) bit
> offsets and will be use to reference PMC irqs.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   include/dt-bindings/clk/at91.h |   22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>   create mode 100644 include/dt-bindings/clk/at91.h
>
> diff --git a/include/dt-bindings/clk/at91.h b/include/dt-bindings/clk/at91.h
> new file mode 100644
> index 0000000..0b4cb99
> --- /dev/null
> +++ b/include/dt-bindings/clk/at91.h
> @@ -0,0 +1,22 @@
> +/*
> + * This header provides constants for AT91 pmc status.
> + *
> + * The constants defined in this header are being used in dts.
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +#ifndef _DT_BINDINGS_CLK_AT91_H
> +#define _DT_BINDINGS_CLK_AT91_H
> +
> +#define AT91_PMC_MOSCS		0		/* MOSCS Flag */
> +#define AT91_PMC_LOCKA		1		/* PLLA Lock */
> +#define AT91_PMC_LOCKB		2		/* PLLB Lock */
> +#define AT91_PMC_MCKRDY		3		/* Master Clock */
> +#define AT91_PMC_LOCKU		6		/* UPLL Lock */
> +#define AT91_PMC_PCKRDY(id)	(8 + (id))	/* Programmable Clock */
> +#define AT91_PMC_MOSCSELS	16		/* Main Oscillator Selection */
> +#define AT91_PMC_MOSCRCS	17		/* Main On-Chip RC */
> +#define AT91_PMC_CFDEV		18		/* Clock Failure Detector Event */
> +
> +#endif
>


-- 
Nicolas Ferre
