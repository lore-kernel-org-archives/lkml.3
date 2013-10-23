Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3JWBTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:19:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54532 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab3JWBTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:19:44 -0400
X-AuditID: cbfee68d-b7fa16d0000029b0-8d-5267242e20c3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 0/9] backlight: atmel-pwm-bl: fixes and clean ups
Date: Wed, 23 Oct 2013 10:19:42 +0900
Message-id: <001801cecf8d$f3834d90$da89e8b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/T8BC/B51pST+KM8m6GNJV8LgAQeScw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zA109lfQgg+0NqhZz1q9hs3h5SNPi
	8sJLrBZ7V0lbnOj7wGpxedccNotvl5vZLdY9fMFksXvXU1aL9fNvsTlweSz4tZXFY+esu+we
	ry7cYfE4MeM3i8ee+T9YPfq2rGL0OH5jO5PH501yARxRXDYpqTmZZalF+nYJXBmTWw6xFNzh
	rPh9/AdjA+MH9i5GTg4JAROJPYumM0PYYhIX7q1n62Lk4hASWMYo8ejDMSaYorlvr0ElpjNK
	TGqaxQTh/AJy5pwGa2cTUJP48uUw2FgRIPtJ7xF2kCJmgfNMEg9ezWIDSQgJOEqs37uZEcTm
	FHCSODDtLiuILSzgKnF803kWEJtFQFVi96QLYKt5BWwltrx5wAxhC0r8mHwPrIZZQEti/c7j
	TBC2vMTmNW+BajiATlWXePRXF+IGI4kvn36yQZSISOx78Y4R5B4JgakcEp1dh5khdglIfJt8
	iAWiV1Zi0wFoUEhKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kqFecmFtc
	mpeul5yfu4kREvm9OxhvH7A+xJgMtH4is5Rocj4wceSVxBsamxlZmJqYGhuZW5qRJqwkzpv0
	MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Nr2p/sex93ulhwnlY9KsQfZLd6y3fJSVnv
	SvTrKxRVWZlqUnzmOWpqae4oSpa+8mv2POUHbWzxHN/SJshOTO5IM56X9tzoRd1u8dJNV7+8
	E+t71HbiAvcPSQ65R0ZsEcu9H73RvHPkKqfwFH3Ts9v83hxq1dyY9aadT+tJYs2VgjMdcm4V
	wkosxRmJhlrMRcWJAMNKCjUSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jQV09lfQggzlrFCzmrF/DZvHykKbF
	5YWXWC32rpK2ONH3gdXi8q45bBbfLjezW6x7+ILJYveup6wW6+ffYnPg8ljwayuLx85Zd9k9
	Xl24w+JxYsZvFo8983+wevRtWcXocfzGdiaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jFmTG45xFJwh7Pi9/EfjA2MH9i7GDk5JARMJOa+vcYGYYtJXLi3Hsjm
	4hASmM4oMalpFhOE8wvImXOaGaSKTUBN4suXw2DdIkD2k94j7CBFzALnmSQevJoFNkpIwFFi
	/d7NjCA2p4CTxIFpd1lBbGEBV4njm86zgNgsAqoSuyddYAKxeQVsJba8ecAMYQtK/Jh8D6yG
	WUBLYv3O40wQtrzE5jVvgWo4gE5Vl3j0VxfiBiOJL59+skGUiEjse/GOcQKj0Cwkk2YhmTQL
	yaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOK8+kdzCuarA4xCjAwajEw2vZ
	nhYkxJpYVlyZe4hRgoNZSYS32RcoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAlJdXEm9o
	bGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYz5W+0ty+ewZPOfkz37
	xOXRlaAww4s/2Nyl1qSVTdgSrr3to6CZinpTxhP2KD+WFguFWfo2UY9Df991mbAguWv37ZtP
	ra6sWmC6YumHLTvieQUrWzUPfzu433XWv8UdpRp9as+slicrz0/cujn7y73lD76biBTHtqrb
	72BZ5b3u/bxHrBGuGquUWIozEg21mIuKEwFXEFUIbwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> These patches fix a few issues and clean up the atmel-pwm-bl driver
> somewhat.
> 
> Johan
> 
> Johan Hovold (9):
>   backlight: atmel-pwm-bl: fix reported brightness
>   backlight: atmel-pwm-bl: fix gpio polarity in remove
>   backlight: atmel-pwm-bl: fix module autoload
>   backlight: atmel-pwm-bl: clean up probe error handling
>   backlight: atmel-pwm-bl: clean up get_intensity
>   backlight: atmel-pwm-bl: remove unused include
>   backlight: atmel-pwm-bl: use gpio_is_valid
>   backlight: atmel-pwm-bl: refactor gpio_on handling
>   backlight: atmel-pwm-bl: use gpio_request_one

++cc Andrew Morton, Tomi Valkeinen, Jean-Christophe Plagniol-Villard

Hi Johan Hovold,

Currently, because there is no git tree for backlight,
backlight patches have been merged to mm-tree by Andrew Morton.
Please, add Andrew Morton to CC list.

Also, there is another way.
If Nicolas Ferre wants to merge these patches, the patches can be
merged through ATMEL-SoC tree with my Acked-by.

Best regards,
Jingoo Han

> 
>  drivers/video/backlight/atmel-pwm-bl.c | 86 ++++++++++++++++------------------
>  1 file changed, 40 insertions(+), 46 deletions(-)

