Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaJHI5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:57:32 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36837 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaJHI53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:57:29 -0400
Date: Wed, 8 Oct 2014 17:57:22 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jack.yoo@skyworksinc.com
Subject: Re: [PATCH] regulator: sky81452: Remove module version
Message-ID: <20141008085722.GC3362@jack-ThinkPad-T520>
References: <1412733463.8255.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412733463.8255.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 09:57:43AM +0800, Axel Lin wrote:
> The module version is unlikely to be updated, use kernel version should be
> enough.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Gyungoh,
> Seems you have added MODULE_VERSION for the sky81452 serial patches.
> Do you really need that and will keep updating it?
> Otherwise, you may want to drop the MODULE_VERSION in sky81452 serial patches.

I see.
I will remove MODULE_VERSION and resumit.
Thank you.

> 
>  drivers/regulator/sky81452-regulator.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
> index 97aff0c..476b80a 100644
> --- a/drivers/regulator/sky81452-regulator.c
> +++ b/drivers/regulator/sky81452-regulator.c
> @@ -127,4 +127,3 @@ module_platform_driver(sky81452_reg_driver);
>  MODULE_DESCRIPTION("Skyworks SKY81452 Regulator driver");
>  MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION("1.0");
> -- 
> 1.9.1
> 
> 
> 
