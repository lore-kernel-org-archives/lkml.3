Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3AOSK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:10:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53542 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3AOSK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:10:56 -0500
Message-ID: <50F59BAD.6000609@wwwdotorg.org>
Date: Tue, 15 Jan 2013 11:10:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] pinctrl/abx500: add AB8500 pinctrl driver
References: <1358242994-5200-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1358242994-5200-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 02:43 AM, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@st.com>
> 
> This adds a subdriver for the AB8500 pinctrl portions.

> diff --git a/drivers/pinctrl/pinctrl-ab8500.c b/drivers/pinctrl/pinctrl-ab8500.c

> +static struct abx500_pinctrl_soc_data ab8500_ranges_soc = {
> +	.gpio_ranges = ab8500_pinranges,
> +	.gpio_num_ranges = ARRAY_SIZE(ab8500_pinranges),
> +	.pins = ab8500_ranges_pins,
> +	.npins = ARRAY_SIZE(ab8500_ranges_pins),
> +	.functions = ab8500_ranges_functions,
> +	.nfunctions = ARRAY_SIZE(ab8500_ranges_functions),
> +	.groups = ab8500_ranges_groups,
> +	.ngroups = ARRAY_SIZE(ab8500_ranges_groups),
> +	.alternate_functions = ab8500_alternate_functions,
> +	.gpio_irq_cluster = ab8500_gpio_irq_cluster,
> +	.ngpio_irq_cluster = ARRAY_SIZE(ab8500_gpio_irq_cluster),
> +	.irq_gpio_rising_offset = AB8500_INT_GPIO6R,
> +	.irq_gpio_falling_offset = AB8500_INT_GPIO6F,
> +	.irq_gpio_factor = 1,
> +};
> +
> +void __devinit
> +abx500_pinctrl_ab8500_init(struct abx500_pinctrl_soc_data **soc)
> +{
> +	*soc = &ab8500_ranges_soc;
> +}

"ranges" in that variable name seems a little odd since it's much more
than ranges... But otherwise, this patch, very briefly,

Reviewed-by: Stephen Warren <swarren@nvidia.com>


