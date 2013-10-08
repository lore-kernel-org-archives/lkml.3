Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3JHQ3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:29:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:64124 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3JHQ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:29:49 -0400
Message-ID: <525432F8.9060600@atmel.com>
Date: Tue, 8 Oct 2013 18:29:44 +0200
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
Subject: Re: [PATCH v3 19/19] ARM: at91: add new compatible strings for pmc
 driver
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375949965-10586-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375949965-10586-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 10:19, Boris BREZILLON :
> This patch adds new compatible string for PMC node to prepare the
> transition to common clk.
>
> These compatible string come from pmc driver in clk subsystem and are
> needed to provide new device tree compatibility with old at91 clks
> (device tree using common clks will use the new compatible strings).
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   arch/arm/mach-at91/clock.c |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index 5f02aea..4d4463a 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -884,6 +884,12 @@ static int __init at91_pmc_init(unsigned long main_clock)
>   #if defined(CONFIG_OF)
>   static struct of_device_id pmc_ids[] = {
>   	{ .compatible = "atmel,at91rm9200-pmc" },
> +	{ .compatible = "atmel,at91sam9260-pmc" },
> +	{ .compatible = "atmel,at91sam9g45-pmc" },
> +	{ .compatible = "atmel,at91sam9n12-pmc" },
> +	{ .compatible = "atmel,at91sam9x5-pmc" },
> +	{ .compatible = "atmel,at91sam9g35-pmc" },

With removal of this compatibility string:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> +	{ .compatible = "atmel,sama5d3-pmc" },
>   	{ /*sentinel*/ }
>   };
>
>


-- 
Nicolas Ferre
