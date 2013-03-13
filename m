Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3CMOUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:20:46 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46183 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab3CMOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <1362662276-20792-8-git-send-email-ian@slimlogic.co.uk>
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
	<1362662276-20792-8-git-send-email-ian@slimlogic.co.uk>
Date: Wed, 13 Mar 2013 15:20:41 +0100
Message-ID: <CACRpkdbG-aXsCDgrLStHGPJFUO=T62DQyhjkhhiTkG8H9OhLGg@mail.gmail.com>
Subject: Re: [PATCH v8 08/12] gpio: palmas: Enable DT support for palmas gpio.
From: Linus Walleij <linus.walleij@linaro.org>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 2:17 PM, Ian Lartey <ian@slimlogic.co.uk> wrote:

> From: J Keerthy <j-keerthy@ti.com>
>
> Enable DT support for palmas gpio.
>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>

This needs to be CC: to devicetree-discuss.

> +static struct of_device_id of_palmas_match_tbl[] = {
> +       { .compatible = "ti,palmas-gpio", },
> +       { .compatible = "ti,palmas-charger-gpio", },
> +       { .compatible = "ti,twl6035-gpio", },
> +       { .compatible = "ti,twl6036-gpio", },
> +       { .compatible = "ti,twl6037-gpio", },
> +       { .compatible = "ti,tps65913-gpio", },
> +       { .compatible = "ti,tps65914-gpio", },
> +       { .compatible = "ti,tps80036-gpio", },
> +       { /* end */ }
> +};

I can see that the binding came in a previous patch in this series, OK.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
