Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491Ab3B0SfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:35:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44108 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3B0SfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:35:19 -0500
Message-ID: <512E51E4.902@wwwdotorg.org>
Date: Wed, 27 Feb 2013 11:35:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: broonie@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk
Subject: Re: [PATCH 3/4] regulator: palmas: Removing duplicated code
References: <1361164446-3216-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1361164446-3216-1-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 10:14 PM, J Keerthy wrote:
> Removing duplicate assignment in the existing code.
...
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
...
> @@ -566,11 +566,6 @@ static void palmas_dt_to_pdata(struct device *dev,
>  			pdata->reg_init[idx]->mode_sleep = prop;
>  
>  		ret = of_property_read_u32(palmas_matches[idx].of_node,
> -				"ti,warm_reset", &prop);
> -		if (!ret)
> -			pdata->reg_init[idx]->warm_reset = prop;
> -
> -		ret = of_property_read_u32(palmas_matches[idx].of_node,

Can you point out where the duplicate of that is; I don't see any other
assignment to warm_reset.
