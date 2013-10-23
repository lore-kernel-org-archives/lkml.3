Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3JWBvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:51:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47682 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab3JWBvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:51:08 -0400
X-AuditID: cbfee68f-b7f836d000001b39-dc-52672b8b9a36
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-6-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-6-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 5/9] backlight: atmel-pwm-bl: clean up get_intensity
Date: Wed, 23 Oct 2013 10:51:06 +0900
Message-id: <001d01cecf92$56ea3ed0$04bebc70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/RjSSCNQz8SS+Sc683SUBK2GQARk/pg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zQ91u7fQgg2e7RCxeHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yOrB7LPi1lcVj56y77B575v9g9ejbsorR4/MmuQDW
	KC6blNSczLLUIn27BK6M/t0XmQo+M1UcuLSHvYFxLVMXIyeHhICJxP9F+6BsMYkL99azdTFy
	cQgJLGOUmNk8nQWm6MWxXWwgtpDAIkaJ7QdMIYp+MUrc6uxjBEmwCahJfPlymB3EFgGyn/Qe
	YQcpYhbYxihxYvk+ZojuSolVDw6CTeUUcJL4vXAJmC0s4CHRfqEPzGYRUJXYdecw0EkcHLwC
	thK/r+WChHkFBCV+TL4HVsIsoCWxfudxJghbXmLzmrfMIOUSAuoSj/7qQpxgJNFzbiIjRImI
	xL4X7xhBzpEQeMku8aWvhQ1ilYDEt8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8C8nmWUg2
	z0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkMjt38F494D1IcZkoPUTmaVEk/OB
	kZ9XEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhb
	chK0V91/NkdYcJbovgyHIuZsIdZc014NtS2dtbc+BW/xnPPPudmnIcIy6uPRG9I2y78b6arn
	LG6tk/Vn4v2QsV2qKqZvZVudbUWe4HOJg1NOPXFNe5sxV+9myIn3MVVqS546R52du+P81NvS
	jNOyfL3mb05avZSh9m1P6pzV1+34j6zedlWJpTgj0VCLuag4EQCaBovC8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAd1u7fQgg7nrBCxeHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yOrB7LPi1lcVj56y77B575v9g9ejbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGf27LzIVfGaqOHBpD3sD41qm
	LkZODgkBE4kXx3axQdhiEhfurQezhQQWMUpsP2DaxcgFZP9ilLjV2ccIkmATUJP48uUwO4gt
	AmQ/6T3CDlLELLCNUeLE8n3MEN2VEqseHGQBsTkFnCR+L1wCZgsLeEi0X+gDs1kEVCV23TkM
	dAUHB6+ArcTva7kgYV4BQYkfk++BlTALaEms33mcCcKWl9i85i0zSLmEgLrEo7+6ECcYSfSc
	m8gIUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOC08k9rBuLLB4hCjAAejEg+vRXtakBBrYllxZe4hRgkOZiUR3mZfoBBvSmJlVWpRfnxR
	aU5q8SHGZKA/JzJLiSbnA1NWXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtS
	i2C2MHFwSjUwRs+MTOCzrueZGzDNLDD9vD9vUmzO34uHs6qz3r2p+Xp7327f/InrZkcu3xPs
	JaP0NFqPV+ySwjwP55U8CStd2QIUn0kWPLXZaHVvnmFcytwdzOfVG7w/9r9wfqy/ZPGtvspr
	zSkzrRZM/2Xtn5crcrqr5839uErj6C1fp0UU77FbeO2NhNZVJZbijERDLeai4kQALQwUV08D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> Clean up get_intensity to increase readability.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)

