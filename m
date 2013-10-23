Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3JWBv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:51:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47821 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3JWBvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:51:55 -0400
X-AuditID: cbfee68f-b7f836d000001b39-3c-52672bb571b7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-7-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-7-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 6/9] backlight: atmel-pwm-bl: remove unused include
Date: Wed, 23 Oct 2013 10:51:49 +0900
Message-id: <001e01cecf92$6ffc3ea0$4ff4bbe0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/WUNnE+/xDqRiWNtjoUuB/b/wARmQ5g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zQ92t2ulBBrv/SFi8PKRpcXnhJVaL
	vaukLU70fWC1uLxrDpvFt8vN7Ba7dz1ldWD3WPBrK4vHzll32T32zP/B6tG3ZRWjx+dNcgGs
	UVw2Kak5mWWpRfp2CVwZb9u72QqOMFXcmNfB0sDYyNTFyMkhIWAi8WrdGUYIW0ziwr31bF2M
	XBxCAssYJaZt7GDvYuQAK+r5kQtSIyQwnVFi4n4ViJpfjBLXG/6xgiTYBNQkvnw5zA5iiwDZ
	T3qPsIMUMQtsY5Q4sXwfM0R3pcSV09OYQYZyCjhJHFkYCGIKC7hLbDyaDlLBIqAqMfXzerCR
	vAK2EhOf7WGDsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPEmeoSj/7qQlxgJNG9t5sVokRE
	Yt+Ld4wg10gIvGSXWHNnFTPELgGJb5MPsUD0ykpsOsAMCQZJiYMrbrBMYJSYhWTzLCSbZyHZ
	PAvJigWMLKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQqK2fwfj3QPWhxiTgdZPZJYSTc4H
	Rn1eSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAs
	vcO7p4qt55Nh+6PWXhVNMx31tu27He/+iT94VmXasy92PaY3DSMzsj28wzLy3/2Umi3lkOHO
	fvSpoe/kGRu5DpVJrFxa56f/jT/6/qEbKiGz8xfei0o7XGgcw7FNx+/g8nTpw48CfQ8uO1Gw
	gHNH0/Frm3Rc18oKVUv9izgmKqi+My1++jIlluKMREMt5qLiRAAzTkyg8AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQd2t2ulBBqffiFi8PKRpcXnhJVaL
	vaukLU70fWC1uLxrDpvFt8vN7Ba7dz1ldWD3WPBrK4vHzll32T32zP/B6tG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM962d7MVHGGquDGvg6WBsZGp
	i5GDQ0LARKLnR24XIyeQKSZx4d56NhBbSGA6o8TE/SpdjFxA9i9GiesN/1hBEmwCahJfvhxm
	B7FFgOwnvUfYQYqYBbYxSpxYvo8ZortS4srpacwgCzgFnCSOLAwEMYUF3CU2Hk0HqWARUJWY
	+nk92EheAVuJic/2sEHYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGeJkdYlHf3UhLjCS6N7b
	zQpRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93
	EyM4JTyT3sG4qsHiEKMAB6MSD69le1qQEGtiWXFl7iFGCQ5mJRHeZl+gEG9KYmVValF+fFFp
	TmrxIcZkoEcnMkuJJucD01VeSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KL
	YLYwcXBKNTD6sHduc0+1PcvRGVOyTMVxoZQf37bUt1clWN592h7Se5nj4l+H/09WtT/2OnZn
	VYeDT1hvZGJ/37T967Jly05zr7d5pXX3w3phh+kFPTtvftf9HXGTU6fkgVeGkEvmSnb/evkc
	7ltPpd353Wu2Jc92XP7twXLxwkuvFx/eGfBRZv/ll7Oi7NyUWIozEg21mIuKEwEXU3qETQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> Remove unused include of clk.h.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 1 -
>  1 file changed, 1 deletion(-)

