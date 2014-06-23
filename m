Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaFWSIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:08:25 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:37915 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaFWSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:08:22 -0400
X-IronPort-AV: E=Sophos;i="5.01,531,1400050800"; 
   d="scan'208";a="35598372"
Message-ID: <53A86C63.7020103@broadcom.com>
Date: Mon, 23 Jun 2014 11:05:23 -0700
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@samsung.com>, <linux-kernel@vger.kernel.org>
CC: <linus.walleij@linaro.org>, <spk.linux@gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: bcm281xx: Staticize bcm281xx_pinctrl_probe
References: <1403523498-3035-1-git-send-email-sachin.kamat@samsung.com>
In-Reply-To: <1403523498-3035-1-git-send-email-sachin.kamat@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

Looks good, thanks.  How did you come across the need for this change?

Regards,
Sherman

On 14-06-23 04:38 AM, Sachin Kamat wrote:
> bcm281xx_pinctrl_probe is local to this file. Make it static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
> ---
>   drivers/pinctrl/pinctrl-bcm281xx.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-bcm281xx.c b/drivers/pinctrl/pinctrl-bcm281xx.c
> index 3bed792b2c03..c5ca9e633fff 100644
> --- a/drivers/pinctrl/pinctrl-bcm281xx.c
> +++ b/drivers/pinctrl/pinctrl-bcm281xx.c
> @@ -1396,7 +1396,7 @@ static struct pinctrl_desc bcm281xx_pinctrl_desc = {
>   	.owner = THIS_MODULE,
>   };
>
> -int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
> +static int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
>   {
>   	struct bcm281xx_pinctrl_data *pdata = &bcm281xx_pinctrl;
>   	struct resource *res;
>

