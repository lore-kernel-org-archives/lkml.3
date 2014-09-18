Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaIROUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:20:50 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42328 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbaIROUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:20:49 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: fan53555: Fixup report wrong vendor message
Date: Thu, 18 Sep 2014 16:23:11 +0200
Message-ID: <1470972.uAI20fM5Y7@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1411048128.18649.1.camel@phoenix>
References: <1411048128.18649.1.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 18. September 2014, 21:48:48 schrieb Axel Lin:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

thanks for catching this silly mistake

Reviewed-by: Heiko Stuebner <heiko@sntech.de>


> ---
>  drivers/regulator/fan53555.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
> index f2f5535..70b31bf 100644
> --- a/drivers/regulator/fan53555.c
> +++ b/drivers/regulator/fan53555.c
> @@ -267,8 +267,7 @@ static int fan53555_device_setup(struct
> fan53555_device_info *di, ret = fan53555_voltages_setup_silergy(di);
>  		break;
>  	default:
> -		dev_err(di->dev,
> -			"vendor %d not supported!\n", di->chip_id);
> +		dev_err(di->dev, "vendor %d not supported!\n", di->vendor);
>  		return -EINVAL;
>  	}

