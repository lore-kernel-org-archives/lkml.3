Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab3JPOPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:15:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:14985 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934787Ab3JPOO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:14:59 -0400
Message-ID: <525E9F5C.9050609@atmel.com>
Date: Wed, 16 Oct 2013 16:14:52 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pinctrl: at91: correct a few typos
References: <1381932753-32081-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1381932753-32081-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/2013 16:12, Alexandre Belloni :
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks.

> ---
>   drivers/pinctrl/pinctrl-at91.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index f350fd2..ad48179 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -243,7 +243,7 @@ static int at91_dt_node_to_map(struct pinctrl_dev *pctldev,
>   	int i;
>
>   	/*
> -	 * first find the group of this node and check if we need create
> +	 * first find the group of this node and check if we need to create
>   	 * config maps for pins
>   	 */
>   	grp = at91_pinctrl_find_group_by_name(info, np->name);
> @@ -564,7 +564,7 @@ static int at91_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
>   		info->functions[selector].name, info->groups[group].name);
>
>   	/* first check that all the pins of the group are valid with a valid
> -	 * paramter */
> +	 * parameter */
>   	for (i = 0; i < npins; i++) {
>   		pin = &pins_conf[i];
>   		ret = pin_check_config(info, info->groups[group].name, i, pin);
> @@ -958,7 +958,7 @@ static int at91_pinctrl_probe_dt(struct platform_device *pdev,
>   	at91_pinctrl_child_count(info, np);
>
>   	if (info->nbanks < 1) {
> -		dev_err(&pdev->dev, "you need to specify atleast one gpio-controller\n");
> +		dev_err(&pdev->dev, "you need to specify at least one gpio-controller\n");
>   		return -EINVAL;
>   	}
>
> @@ -1495,7 +1495,7 @@ static int at91_gpio_of_irq_setup(struct device_node *node,
>   	if (at91_gpio->pioc_idx)
>   		prev = gpio_chips[at91_gpio->pioc_idx - 1];
>
> -	/* The toplevel handler handles one bank of GPIOs, except
> +	/* The top level handler handles one bank of GPIOs, except
>   	 * on some SoC it can handles up to three...
>   	 * We only set up the handler for the first of the list.
>   	 */
>


-- 
Nicolas Ferre
