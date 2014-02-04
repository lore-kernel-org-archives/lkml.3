Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaBDUOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:14:32 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:47771 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaBDUOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:14:30 -0500
X-IronPort-AV: E=Sophos;i="4.95,781,1384329600"; 
   d="scan'208";a="12707611"
Message-ID: <52F149F4.6040105@broadcom.com>
Date: Tue, 4 Feb 2014 12:13:40 -0800
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Christian Daudt <bcm@fixthebug.org>
Subject: Re: [PATCH] pinctrl: capri: Make capri_pinctrl_probe static
References: <1391503770.19947.0.camel@phoenix>
In-Reply-To: <1391503770.19947.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-02-04 12:49 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/pinctrl/pinctrl-capri.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-capri.c b/drivers/pinctrl/pinctrl-capri.c
> index 4669c53..b4aa8e3 100644
> --- a/drivers/pinctrl/pinctrl-capri.c
> +++ b/drivers/pinctrl/pinctrl-capri.c
> @@ -1390,7 +1390,7 @@ static struct pinctrl_desc capri_pinctrl_desc = {
>   	.owner = THIS_MODULE,
>   };
>
> -int __init capri_pinctrl_probe(struct platform_device *pdev)
> +static int __init capri_pinctrl_probe(struct platform_device *pdev)
>   {
>   	struct capri_pinctrl_data *pdata = &capri_pinctrl;
>   	struct resource *res;
>
Note that this will collide with the capri->bcm281xx renaming patches.

Linus, Christian, are those patches going in soon?

Thanks,
Sherman
