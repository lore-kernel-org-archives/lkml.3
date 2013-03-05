Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3CEWmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:42:01 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:63750 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3CEWmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:42:00 -0500
Message-ID: <513674B2.6040106@gmail.com>
Date: Wed, 06 Mar 2013 09:41:54 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH V2] backlight: ep93xx_bl: remove incorrect __init annotation
References: <015501ce18b6$3819c310$a84d4930$%han@samsung.com> <015701ce18b6$f7f42450$e7dc6cf0$%han@samsung.com>
In-Reply-To: <015701ce18b6$f7f42450$e7dc6cf0$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/13 20:02, Jingoo Han wrote:
> When platform_driver_probe() is not used, bind/unbind via sysfs is
> enabled. Thus, __init/__exit annotations should be removed from
> probe()/remove().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Ryan Mallon <rmallon@gmail.com>

> ---
> Changes since v1:
> - Fix typo of the subject: __exit --> __init
> 
>  drivers/video/backlight/ep93xx_bl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
> index ef3e21e..fd073b2 100644
> --- a/drivers/video/backlight/ep93xx_bl.c
> +++ b/drivers/video/backlight/ep93xx_bl.c
> @@ -60,7 +60,7 @@ static const struct backlight_ops ep93xxbl_ops = {
>  	.get_brightness	= ep93xxbl_get_brightness,
>  };
>  
> -static int __init ep93xxbl_probe(struct platform_device *dev)
> +static int ep93xxbl_probe(struct platform_device *dev)
>  {
>  	struct ep93xxbl *ep93xxbl;
>  	struct backlight_device *bl;
> 

