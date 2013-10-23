Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3JWBwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:52:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47471 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3JWBwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:52:34 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-83-52672be0a53d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-8-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-8-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 7/9] backlight: atmel-pwm-bl: use gpio_is_valid
Date: Wed, 23 Oct 2013 10:52:32 +0900
Message-id: <001f01cecf92$89d62250$9d8266f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/WUc551aGn1TbOrraqQ2rxAbAARn14A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zI90H2ulBBg9X61u8PKRpcXnhJVaL
	vaukLU70fWC1uLxrDpvFt8vN7Ba7dz1ldWD3WPBrK4vHzll32T32zP/B6tG3ZRWjx+dNcgGs
	UVw2Kak5mWWpRfp2CVwZfdePMBV0M1fsndfA2MC4l6mLkZNDQsBE4tqPHhYIW0ziwr31bF2M
	XBxCAssYJSbe/cMCU/T/8wxWiMQiRolpF5exgiSEBH4xSnx55QRiswmoSXz5cpgdxBYBsp/0
	HmEHaWAW2MYocWL5PmaIhkqJ/p8nwVZzCjhJrD8/CWgQB4ewgLPEoh+lIGEWAVWJz0uugs3h
	FbCVWPvhOSuELSjxY/I9sIOYBbQk1u88zgRhy0tsXvOWGWSMhIC6xKO/uhAnGEk8ufwMqkRE
	Yt+Ld4wg50gIvGSXmNY+gxVil4DEt8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8C8nmWUg2
	z0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MkMidsIPx3gHrQ4zJQOsnMkuJJucD
	Iz+vJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhi7
	ly/ZPWd/3bK3/H6muR1eEk9UW5uLzALf+z2PO3d3ykGbCSEf2WWU2SLnc/EvcD/eczp5SW8/
	+4O54nz/9a5qs72IzpjO1lwrfu7NZJUnEaunv1UpvLDSSP/Dsk2ZkwQzFoqJ/DSxjeqflukz
	/7G4Jffn3Xv+aZ/qy6lmjhNQYlQ9wxlsEqPEUpyRaKjFXFScCAAaEhKL8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAd0H2ulBBj/naFu8PKRpcXnhJVaL
	vaukLU70fWC1uLxrDpvFt8vN7Ba7dz1ldWD3WPBrK4vHzll32T32zP/B6tG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM/quH2Eq6Gau2DuvgbGBcS9T
	FyMnh4SAicT/zzNYIWwxiQv31rN1MXJxCAksYpSYdnEZWEJI4BejxJdXTiA2m4CaxJcvh9lB
	bBEg+0nvEXaQBmaBbYwSJ5bvY4ZoqJTo/3kSbAOngJPE+vOTgAZxcAgLOEss+lEKEmYRUJX4
	vOQq2BxeAVuJtR+es0LYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGWSMhIC6xKO/uhAnGEk8
	ufwMqkREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcFp4Jr2DcVWDxSFGAQ5GJR5ey/a0ICHWxLLiytxDjBIczEoivM2+QCHelMTKqtSi/Pii
	0pzU4kOMyUCPTmSWEk3OB6asvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphak
	FsFsYeLglGpgnKl65tuOY8f3z6uYHJsnuK8hc6pqkdifPdrPxF3anuZar9dMObu84sudpPbC
	a7/2OH3gnFqu7Z28reB7Cd9szk0LeiM/zVzRvO5EQGFEldL/X/umVPvwzJJKeeY7tyzao9O2
	1Wp/eXH12Rz3L97/Ttb27uveZv76gf2Jj/++GVZGnNn7KMP0uxJLcUaioRZzUXEiAPVZrupP	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> Use gpio_is_valid rather than open coding the more restrictive != -1
> test.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

