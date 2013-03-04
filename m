Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3CDI7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:59:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24658 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3CDI7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:59:34 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-96-51346275e7bf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <015501ce18b6$3819c310$a84d4930$%han@samsung.com>
In-reply-to: <015501ce18b6$3819c310$a84d4930$%han@samsung.com>
Subject: Re: [PATCH] backlight: ep93xx_bl: remove incorrect __exit annotation
Date: Mon, 04 Mar 2013 17:59:32 +0900
Message-id: <015601ce18b6$96a73ca0$c3f5b5e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YtjgDnfWDblDbSP+ou/QMT1c6bgAADV5g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zA93SJJNAg7YbQhZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aiu4sZ
	C25zVLx7fpG5gXE6excjB4eEgIlE336FLkZOIFNM4sK99WxdjFwcQgLLGCUWPXvCBpEwkfh2
	+hc7iC0kMJ1R4sAOXYiiX4wSv6fsZgVJsAmoSXz5chhsqIiAvkRbiwZImFmgVGLrg/csEL22
	ElenfGACsTkF7CSebNjLClIuLOAr8WS7KEiYRUBV4n3vWbC1vEDlH/v7mCFsQYkfk++xQIzU
	kli/8zgThC0vsXnNW2aIV9QlHv3VhTjASGLLRF+IChGJfS/eMYIcLCFwil3i4IpFjBCrBCS+
	TT7EAtEqK7HpADPEs5JAJTdYJjBKzEKyeBaSxbOQLJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5
	xaV56XrJ+bmbGCHR2LeD8eYB60OMyUDrJzJLiSbnA6M5ryTe0NjYxMzE1MTc0tTclDRhJXFe
	+UsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYk916FxcdDfhTGLZV0Xhbf6aK+Oq4aY8E
	zO8enTVBNowrilM17gbbpcnnkr/4HFo3m0ntZkl38owlm71EmUsPM1ep37ON9Xn46sTp4pxT
	60/Ydj9h//72cpxRW+cVN67GVxcef7o/7V1YwfzwI+yWt4/z3GlpW3b6ArvndI+9zUv5dmy9
	lLsoSYmlOCPRUIu5qDgRAM0pE3XcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd3SJJNAg0vr+SzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMRXcXMxbc5qh49/wicwPjdPYuRk4OCQETiW+nf0HZYhIX7q1n
	A7GFBKYzShzYodvFyAVk/2KU+D1lNytIgk1ATeLLl8NADRwcIgL6Em0tGiBhZoFSia0P3rNA
	9NpKXJ3ygQnE5hSwk3iyYS8rSLmwgK/Ek+2iIGEWAVWJ971nwVbxApV/7O9jhrAFJX5MvscC
	MVJLYv3O40wQtrzE5jVvmUHGSAioSzz6qwtxgJHElom+EBUiEvtevGOcwCg0C8mgWUgGzUIy
	aBaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqP9mfQOxlUNFocYBTgYlXh4BT4Z
	BwqxJpYVV+YeYpTgYFYS4Y1IMAkU4k1JrKxKLcqPLyrNSS0+xJgM9OdEZinR5HxgIsoriTc0
	NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYyFElnPVB1MH+/w++gj
	qLZtk8qOWxOlGxy/Jz78zPK4+N7HgPks1449FwmQuH7/XXng889vT5wrLH++yP+N6r2Zq1ac
	331SMtrFWTiyWLOyROixYARn+NzbRtnz94QwX999TKOdPejr1de91cZmuw76Bz37+69o4d93
	hq4xExn9OPc0cYm/P5OuxFKckWioxVxUnAgANgQlQzoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 04, 2013 5:57 PM, Jingoo Han wrote:
> Subject: [PATCH] backlight: ep93xx_bl: remove incorrect __exit annotation

Sorry, subject is wrong.
__exit should be __init.

I will send the v2 patch, soon.

> 
> When platform_driver_probe() is not used, bind/unbind via sysfs is
> enabled. Thus, __init/__exit annotations should be removed from
> probe()/remove().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
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
> --
> 1.7.2.5


