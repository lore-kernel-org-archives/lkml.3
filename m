Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3JHKa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:30:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:5153 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3JHKaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:30:24 -0400
Message-ID: <5253DEBD.7010904@atmel.com>
Date: Tue, 8 Oct 2013 12:30:21 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, "Felipe Balbi" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 07/19] clk: at91: add pll id macros for pll dt bindings
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375942160-8881-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375942160-8881-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 08:09, Boris BREZILLON :
> This patch adds the PLL id macros which will be used by pll dt definitions.

It is not needed, drop it. Just document the values in the DT biding and 
it will be fine.

>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   include/dt-bindings/clk/at91/common/clk-pll.h |   13 +++++++++++++
>   1 file changed, 13 insertions(+)
>   create mode 100644 include/dt-bindings/clk/at91/common/clk-pll.h
>
> diff --git a/include/dt-bindings/clk/at91/common/clk-pll.h b/include/dt-bindings/clk/at91/common/clk-pll.h
> new file mode 100644
> index 0000000..93ec849
> --- /dev/null
> +++ b/include/dt-bindings/clk/at91/common/clk-pll.h
> @@ -0,0 +1,13 @@
> +/*
> + * This header provides constants for AT91 pll ids.
> + *
> + * The constants defined in this header are being used in dts.
> + */
> +
> +#ifndef _DT_BINDINGS_CLK_AT91_PLL_H
> +#define _DT_BINDINGS_CLK_AT91_PLL_H
> +
> +#define AT91_PLLA_CLK		0	/* PLLA clk id */
> +#define AT91_PLLB_CLK		1	/* PLLB clk id */
> +
> +#endif
>


-- 
Nicolas Ferre
