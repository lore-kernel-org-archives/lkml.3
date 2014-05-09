Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaEIIuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:50:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40639 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaEIIuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:50:20 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-98-536c96ca2fcf
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <536C96CA.6000102@samsung.com>
Date: Fri, 09 May 2014 17:50:18 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Takashi Iwai <tiwai@suse.de>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] drm/exynos: Fix double locks at PM resume
References: <1399616055-13427-1-git-send-email-tiwai@suse.de>
 <1399616055-13427-2-git-send-email-tiwai@suse.de>
In-reply-to: <1399616055-13427-2-git-send-email-tiwai@suse.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkQPfUtJxgg1/rNCx6z51kslj48C6z
	xZWv79ksLu+aw2bxcvMbJgdWj73fFrB4bP/2gNXjfvdxJo/Np6s9Pm+SC2CN4rJJSc3JLEst
	0rdL4MpYdaaFtWATV8XKL9+YGxhPc3QxcnJICJhIbNi+gB3CFpO4cG89WxcjF4eQwFJGiZYV
	W9lgin43nQKzhQSmM0q8uRMPYvMKCEr8mHyPBcRmFlCXmDRvETOELSIxce5ldghbW2LZwtfM
	EENfMUr8vDmVHaJZS+JX3wkwm0VAVeLgshawBWxA9sQV98FsUYEwiRevdoENFRFQkHjz6h4j
	yCBmgR5GiWl7F4BtFhZwklg4ewfUdYUSr9ccAotzCthJ/FnXwQrSICFwiF3i7u2rjBDbBCS+
	TQYp4gBKyEpsOsAM8aWkxMEVN1gmMIrPQvLcLCTPzULy3Cwkzy1gZFnFKJpakFxQnJReZKxX
	nJhbXJqXrpecn7uJERiTp/8969/BePeA9SHGZKD1E5mlRJPzgTGdVxJvaGxmZGFqYmpsZG5p
	Rpqwkjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY/ZcnLp+WHK1pMr/QXLJzp6RC
	8Ks5OceS15StbW1cPtn+hZLHUsVDib3Won5TmRYw/RX/JLlqZ+C8D9LSK3eIay7wdK36+stj
	CrfjzYB5N+PK7fdM3dD+h1PKzCA3T+nXtwD2UgamXDbje58Oe+Y6O+1MEwjgknGZVH/QZsLX
	lSb3umasPjVJiaU4I9FQi7moOBEAt+Spr98CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoO6paTnBBodaFC16z51kslj48C6z
	xZWv79ksLu+aw2bxcvMbJgdWj73fFrB4bP/2gNXjfvdxJo/Np6s9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2P7yOVPBAq6KgzOvMjcw7uToYuTkkBAwkfjd
	dIoNwhaTuHBvPZgtJDCdUeLNnXgQm1dAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvE3MXI
	BVT+ilHi582p7BD1WhK/+k6A2SwCqhIHl7WAzWQDsieuuA9miwqESbx4tYsZxBYRUJB48+oe
	I8ggZoEeRolpexewgCSEBZwkFs7eAXVQocTrNYfA4pwCdhJ/1nWwTmAUmIXkvlkI981Cct8C
	RuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR+0xqB+PKBotDjAIcjEo8vC+mZAcLsSaW
	FVfmHmKU4GBWEuFVnpITLMSbklhZlVqUH19UmpNafIgxGei7icxSosn5wMSSVxJvaGxiZmRp
	ZG5oYWRsTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MR85lqO6WtVob5G9/oMjnZ/m0
	U2IM0Rs1g3s5LD4Y7JWaXs9etItVL23t37xdwQ/03ujOVf2WK3OnrXwim3JavEbUtbCrLsvr
	j9xqFbCUbfd/VXzl++tX27Pnf974eP7iZ7vf3Nu75e27KY+uGB37cFdocll/zIm7a/Zw8rW+
	Mb5xIrJ9jhxngxJLcUaioRZzUXEiAIDPb8IiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2014년 05월 09일 15:14, Takashi Iwai wrote:
> The recent commit [3ea87855: drm/helper: lock all around force mode
> restore] introduced drm_modeset_lock_all() in
> drm_helper_resume_force_mode() itself, while exynos driver takes this
> lock before calling it.  Move the function call outside the lock for
> avoiding a deadlock.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index 2d27ba23a6a8..79410b0c4bbf 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -183,9 +183,9 @@ static int exynos_drm_resume(struct drm_device *dev)
>  		if (connector->funcs->dpms)
>  			connector->funcs->dpms(connector, connector->dpms);
>  	}
> +	drm_modeset_unlock_all(dev);
>  
>  	drm_helper_resume_force_mode(dev);
> -	drm_modeset_unlock_all(dev);

This patch had already been posted but your patch comments what was the
problem more exactly than below one.
        http://www.spinics.net/lists/dri-devel/msg58586.html

So picked it up instead of previous one.

Thanks,
Inki Dae

>  
>  	return 0;
>  }
> 

