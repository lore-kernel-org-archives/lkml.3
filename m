Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab3JCEh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:37:58 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46275 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab3JCEh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <1380370138-3513-11-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
	<1380370138-3513-11-git-send-email-sachin.kamat@linaro.org>
Date: Thu, 3 Oct 2013 10:07:55 +0530
Message-ID: <CAKohpon=PO+U2DGJQJKa+9MhxoVC3ALnJYjv8_DEUDMivGZREQ@mail.gmail.com>
Subject: Re: [PATCH 11/11] pinctrl: plgpio: Remove redundant of_match_ptr
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 September 2013 17:38, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> The data structure of_match_ptr() protects is always compiled in.

of_match_ptr() isn't a data structure.. And also what does "protects" mean here?

> Hence of_match_ptr() is not needed.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/pinctrl/spear/pinctrl-plgpio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
> index 0a7f0bdb..ff2940e 100644
> --- a/drivers/pinctrl/spear/pinctrl-plgpio.c
> +++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
> @@ -735,7 +735,7 @@ static struct platform_driver plgpio_driver = {
>                 .owner = THIS_MODULE,
>                 .name = "spear-plgpio",
>                 .pm = &plgpio_dev_pm_ops,
> -               .of_match_table = of_match_ptr(plgpio_of_match),
> +               .of_match_table = plgpio_of_match,
>         },
>  };

Patch is okay otherwise.
