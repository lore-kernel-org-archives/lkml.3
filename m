Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3JWByF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:54:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47714 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3JWByC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:54:02 -0400
X-AuditID: cbfee691-b7f866d000001b8c-29-52672c398aa8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-10-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-10-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 9/9] backlight: atmel-pwm-bl: use gpio_request_one
Date: Wed, 23 Oct 2013 10:54:01 +0900
Message-id: <002101cecf92$bef81fb0$3ce85f10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/WUl+zyDUZhRimolRiMFgVZGAARrdkw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zfV1LnfQgg//bLC1eHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yOrB7LPi1lcVj56y77B575v9g9ejbsorR4/MmuQDW
	KC6blNSczLLUIn27BK6M3iVfWQrmMle0H7jO3MB4gamLkZNDQsBE4teZK+wQtpjEhXvr2boY
	uTiEBJYxSrzteskIUzRj1ydGiMR0Ronjrf9ZIZxfjBKT/31hAaliE1CT+PLlMNgoESD7Se8R
	dpAiZoFtjBInlu9jBkkICVRJPN66GqyIU8BZYtOafWArhAXcJD5fuA02iEVAVeJN01Q2EJtX
	wFbi7K5mRghbUOLH5HtgNcwCWhLrdx5ngrDlJTaveQs0nwPoVHWJR391IW4wkrh/5Rg7RImI
	xL4X78A+kBB4yy4x68EjVohdAhLfJh9igeiVldh0gBniY0mJgytusExglJiFZPMsJJtnIdk8
	C8mKBYwsqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzFConfiDsb7B6wPMSYDrZ/ILCWanA+M
	/rySeENjMyMLUxNTYyNzSzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYCz9
	EsewqCuwmPnwVxMB5fbNUb+upX34c+Wm5N4CBrbN9/Puz22ZEXf4BefDghD7s590nJ2EKu4F
	TrF2stsa9Dy6/d8plyObtS0sFfb0x89dw//3+ueFNjv0/fenvLu1Vsi14WDbVqeDlYKafT0m
	kW5z96ZJbZwWHR6m4q/w/51v2t+T/RMZQ5VYijMSDbWYi4oTAbZfjlP0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV1LnfQgg78zTC1eHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yOrB7LPi1lcVj56y77B575v9g9ejbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGb1LvrIUzGWuaD9wnbmB8QJT
	FyMnh4SAicSMXZ8YIWwxiQv31rN1MXJxCAlMZ5Q43vqfFcL5xSgx+d8XFpAqNgE1iS9fDrOD
	2CJA9pPeI+wgRcwC2xglTizfxwySEBKokni8dTVYEaeAs8SmNfvAVggLuEl8vnAbbBCLgKrE
	m6apbCA2r4CtxNldzYwQtqDEj8n3wGqYBbQk1u88zgRhy0tsXvMWaD4H0KnqEo/+6kLcYCRx
	/8oxdogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGMGp4Zn0DsZVDRaHGAU4GJV4eC3b04KEWBPLiitzDzFKcDArifA2+wKFeFMSK6tSi/Lj
	i0pzUosPMSYDPTqRWUo0OR+YtvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpa
	kFoEs4WJg1OqgZF5rsa9xZce/LRpMr6xl2fqtKyj03L2bqndcfS337mnZzcVaSwxlfth+D37
	o8hFPbk7ajcZZwRdOdXHceC7vHR/08WJf6V3O0XqG+0MuaxWXKWttuboXpfX2w+zH6x6E3JB
	SaTPzGjG4eW3Nm16UzRj7p+3Dx2OXymdWhrIw5P5wNo63Kb4778LSizFGYmGWsxFxYkALfBO
	YFEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> Use devm_gpio_request_one rather than requesting and setting direction
> in two calls.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)

