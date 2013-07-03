Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3GCBwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:52:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32270 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3GCBwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:52:18 -0400
X-AuditID: cbfee691-b7fef6d000002d62-26-51d383d0f5e3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Oskar Andero'" <oskar.andero@sonymobile.com>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Radovan Lekanovic'" <Radovan.Lekanovic@sonymobile.com>,
        "'Shingo Nakao'" <shingo.x.nakao@sonymobile.com>,
        "'Milo Kim'" <milo.kim@ti.com>, "'Richard Purdie'" <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>
References: <1372767354-16499-1-git-send-email-oskar.andero@sonymobile.com>
In-reply-to: <1372767354-16499-1-git-send-email-oskar.andero@sonymobile.com>
Subject: Re: [PATCH] backlight: lp855x: set zero brightness at FBBLANK
Date: Wed, 03 Jul 2013 10:52:16 +0900
Message-id: <001e01ce778f$f2033c10$d609b430$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIxjslNqYigEdFvW5A6Bjhxk1E9u5iMAX8Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zI90LzZcDDa41mlpcXniJ1eJE3wdW
	i8u75rBZLP+1jsVixykRi3UPXzBZnN6wmMli966nrBbLX31msVg//xabA5fHqwt3WDz2zP/B
	6tG3ZRWjx50Dt1k9jt/YzuTxeZNcAFsUl01Kak5mWWqRvl0CV8bFyxIFFzkrtm16xNjA+IW9
	i5GDQ0LAROLSHJ8uRk4gU0ziwr31bF2MXBxCAssYJe5+b2WCSJhI7Ov6DZWYziix4ftDKOcX
	o8SWa+/ZQarYBNQkvnw5DGaLCORK7Ho9lQmkiFlgH5PElOt7GUESQgLeErc+dLCC2JwCPhL3
	bvwBaxAWcJOYfeksG8hJLAKqEvN3C4GEeQUsJe5tmsgOYQtK/Jh8jwXEZhbQkli/8zgThC0v
	sXnNW2aISxUkdpx9zQgyRkTASGLLFEuIEhGJfS/eMUKUdHJILNwHFmcREJD4NvkQCyQgZCU2
	HYCaIilxcMUNlgmMErOQLJ6FZPEsJItnIdmwgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7u
	JkZIfE/cwXj/gPUhxmSg9ROZpUST84HpIa8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjFLhZw/lM3SoHWZ81X9l1qb6n1pJxwwSO07ayqf/77XM
	1djvJPQl4JR424NIkzWls+/tsepKYeZY/eqcfVHBpKCnUQEZ/Xo+op+vVgQ5/Jirs6KiM7+h
	4L1MdbZTTG5hg9TKsx6PmaY4Ji2X+nCQxdBmcVaIjccV7d2T5stuyowSN3x8ZP53JZbijERD
	Leai4kQAQIiYDQUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQd0LzZcDDU5vMLC4vPASq8WJvg+s
	Fpd3zWGzWP5rHYvFjlMiFusevmCyOL1hMZPF7l1PWS2Wv/rMYrF+/i02By6PVxfusHjsmf+D
	1aNvyypGjzsHbrN6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
	Q0sLcyWFvMTcVFslF58AXbfMHKDTlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGEdYwZFy9LFFzkrNi26RFjA+MX9i5GTg4JAROJfV2/2SBsMYkL99YD2VwcQgLTGSU2fH8I
	5fxilNhy7T1YB5uAmsSXL4fBbBGBXIldr6cygRQxC+xjkphyfS8jSEJIwFvi1ocOVhCbU8BH
	4t6NP2ANwgJuErMvnQWaysHBIqAqMX+3EEiYV8BS4t6miewQtqDEj8n3WEBsZgEtifU7jzNB
	2PISm9e8ZYa4VEFix9nXjCBjRASMJLZMsYQoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZ
	xSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcQJ5J7WBc2WBxiFGAg1GJh9fh2aVAIdbEsuLK
	3EOMEhzMSiK8WlmXA4V4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5jc8kriDY1NzIwsjcws
	jEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsXn3rJSdzE9ZPBwt5jNuLFNcJDl5
	gUiMepICT5tH2+nVmjv36mXFXhGdsKw8ce//2p/WB2aEcV9envWw+U24Lc/By/KaP60WM6/Q
	PNqkLPdH5Mwuf4cA8z/LGN458xmstKyscLmWz39DbqXey6v5WSGXdr81tfPZIZan0BxwKefA
	ht5uHo4pSizFGYmGWsxFxYkA4BchvmQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 02, 2013 9:16 PM, Oskar Andero wrote:
> 
> From: Shingo Nakao <shingo.x.nakao@sonymobile.com>
> 
> When backlight turns on early from display, a white line can be
> seen on the screen. Therefore make sure backlight is off when we
> are under an fb blank event.
> 
> Signed-off-by: Shingo Nakao <shingo.x.nakao@sonymobile.com>
> Cc: Milo Kim <milo.kim@ti.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/lp855x_bl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
> index a0e1e02..c0b41f1 100644
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -246,7 +246,7 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
>  {
>  	struct lp855x *lp = bl_get_data(bl);
> 
> -	if (bl->props.state & BL_CORE_SUSPENDED)
> +	if (bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
>  		bl->props.brightness = 0;
> 
>  	if (lp->mode == PWM_BASED) {
> --
> 1.8.1.5
> 


