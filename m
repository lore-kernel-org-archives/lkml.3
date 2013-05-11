Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3EKFPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 01:15:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25615 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3EKFPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 01:15:07 -0400
X-AuditID: cbfee691-b7fe56d000004b96-c7-518dd3d95071
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wolfram Sang'" <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-40-git-send-email-wsa@the-dreams.de>
In-reply-to: <1368173847-5661-40-git-send-email-wsa@the-dreams.de>
Subject: Re: [RFC 39/42] arch/arm/plat-samsung: don't check resource with
 devm_ioremap_resource
Date: Sat, 11 May 2013 14:15:05 +0900
Message-id: <002601ce4e06$7f68fbc0$7e3af340$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKrVsRnZVwbWOaUrA6bMaaf4JBF+gHOl/44lzbqTkA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zfd2bl3sDDS7fMbKYtO4Ak8XlhZdY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/FyhOzmB04PFqae9g8/q56weyxeUm9R9+WVYwe
	J089YfH4vEkugC2KyyYlNSezLLVI3y6BK+PgsofMBTM4K37MS2lg3MHexcjJISFgItE66Rgj
	hC0mceHeerYuRi4OIYFljBIPdh5khCk6fu8uM0RiOqPEvhUbmSCcX4wSc5a/YAWpYhNQk/jy
	5TDYWBEBF4mN/2+BjWIWeMwo8XDOIhaQhJBAhcS9My/AxnIKOEncfr0MaBIHh7BAosTUpZ4g
	YRYBVYmjs++BlfMKWEps79/KBmELSvyYDBFnFtCSWL/zOBOELS+xec1bZohLFSR2nH3NCHGD
	lcShpX1Q9SIS+168YwS5R0LgK7vEmmMb2SCWCUh8m3yIBeQGCQFZiU0HoOZIShxccYNlAqPE
	LCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERLPE3cw3j9gfYgx
	GWj9RGYp0eR8YDrIK4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1
	+BAjEwenVAMjk9vG2FMLVP9z1zLrrJsfePvZ8zU11zWZil9wzIk+nL6M0XXZqvQ37f/FPBRy
	wl/8NJ7UaPs3U0hi3lrXtBTDGWuvc4rsDzh5snrlh4sVu8xnxdUW9/gxWP2NL/U9Mzdzn9Sm
	wtVnWEQ3BzL3hOpt9Sj7tll4t8C0nKVbL6zfuKWeg+2PDONpJZbijERDLeai4kQAEjfuNv0C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd2bl3sDDe7t0bOYtO4Ak8XlhZdY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/FyhOzmB04PFqae9g8/q56weyxeUm9R9+WVYwe
	J089YfH4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGwWUPmQtm
	cFb8mJfSwLiDvYuRk0NCwETi+L27zBC2mMSFe+vZuhi5OIQEpjNK7FuxkQnC+cUoMWf5C1aQ
	KjYBNYkvXw6DdYsIuEhs/H8LrINZ4DGjxMM5i1hAEkICFRL3zrxgBLE5BZwkbr9eBjSJg0NY
	IFFi6lJPkDCLgKrE0dn3wMp5BSwltvdvZYOwBSV+TIaIMwtoSazfeZwJwpaX2LzmLdSlChI7
	zr5mhLjBSuLQ0j6oehGJfS/eMU5gFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxjByeKZ1A7GlQ0WhxgFOBiVeHgVBHoDhVgTy4orcw8xSnAwK4nwHpkOFOJN
	SaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YCLLK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBA
	emJJanZqakFqEcwWJg5OqQbG1lnxjyP8Bbw+L9NaJZYRtMyQJ0Zkbc8Rc7fKt+9O9m9PfuAd
	c9tApX/D5DKLTbd3b1Y5+bdJtv7MMsnCxSL+ibNlZrHlxjH7L56ff873wYb8kIj082+SjDWE
	2CYIFBlGJhtWuvb83bitv+vsqj0J3hf6LzSXFRnwVk+K3rny9oWGdCOdjFdKLMUZiYZazEXF
	iQBuW/CvWgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 10, 2013 5:17 PM, Wolfram Sang wrote:
> 
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  arch/arm/plat-samsung/adc.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
> index ca07cb1..79690f2 100644
> --- a/arch/arm/plat-samsung/adc.c
> +++ b/arch/arm/plat-samsung/adc.c
> @@ -381,11 +381,6 @@ static int s3c_adc_probe(struct platform_device *pdev)
>  	}
> 
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!regs) {
> -		dev_err(dev, "failed to find registers\n");
> -		return -ENXIO;
> -	}
> -
>  	adc->regs = devm_ioremap_resource(dev, regs);
>  	if (IS_ERR(adc->regs))
>  		return PTR_ERR(adc->regs);
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

