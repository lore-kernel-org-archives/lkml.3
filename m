Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3FRJYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:24:49 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:49138 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab3FRJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <1371546267-22093-3-git-send-email-sachin.kamat@linaro.org>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
	<1371546267-22093-3-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 18 Jun 2013 14:54:47 +0530
Message-ID: <CAKohpo=ZAsrcMk5CVbAO_viBk3XdP8wR+4G4ztH4jhi05eU19A@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: spear/plgpio: Staticize spear310_o2p
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2013 14:34, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> 'spear310_o2p' is referenced only in this file.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/pinctrl/spear/pinctrl-plgpio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
> index 6b090be..0a7f0bdb 100644
> --- a/drivers/pinctrl/spear/pinctrl-plgpio.c
> +++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
> @@ -441,7 +441,7 @@ static int spear310_p2o(int pin)
>         return offset;
>  }
>
> -int spear310_o2p(int offset)
> +static int spear310_o2p(int offset)
>  {
>         if (offset <= 3)
>                 return 101 - offset;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
