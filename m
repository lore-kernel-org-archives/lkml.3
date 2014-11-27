Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaK0LWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:22:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31361 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaK0LWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:22:46 -0500
X-AuditID: cbfee691-f79b86d000004a5a-40-54770982d054
Message-id: <54770982.3080502@samsung.com>
Date: Thu, 27 Nov 2014 20:22:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Mark Rutland <Mark.Rutland@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "olof@lixom.net" <olof@lixom.net>, Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 15/19] arm64: exynos5433: Enable ARMv8-based Exynos5433 SoC
 support
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-16-git-send-email-cw00.choi@samsung.com>
 <20141127111839.GD11511@e104818-lin.cambridge.arm.com>
In-reply-to: <20141127111839.GD11511@e104818-lin.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkULeJszzEYPFsQ4vHaxYzWfyddIzd
	4v2yHkaLy/u1LeYfOcdq8WdCK5vFpPsTWCxu/GpjtehdcJXN4mzTG3aLKX+WM1lsenyN1eLy
	rjlsFjPO72OyWHr9IpPFqeuf2SwOv2lntZgx+SWbxbEZSxgtVu36w2jx8uMJFgdRjzXz1jB6
	/P41idFj56y77B53ru1h89i8pN7jyokmVo++LasYPT5vkgvgiOKySUnNySxLLdK3S+DKmHt1
	IWvBWbaKG19lGxjnsXYxcnJICJhIPGv9xQRhi0lcuLeeDcQWEljKKLH4uTZMzd65x1i6GLmA
	4osYJTpXbGKCcF4zSix8dJ4ZpIpXQEti7fkfYJNYBFQlNr7tAIuzAcX3v7gBNlVUIExi5fQr
	LBD1ghI/Jt8Ds0UEdCUutE0Bs5kFtnBI7N/uBGILC0RKfN99gx1i2W5Gidf7e4GGcnBwCjhL
	9P+VhajXkdjfOo0NwpaX2LzmLTNIvYTACQ6Jy1tOsEEcJCDxbfIhFpBeCQFZiU0HmCE+k5Q4
	uOIGywRGsVlITpqFZOwsJGMXMDKvYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAhMDaf/PZu4
	g/H+AetDjAIcjEo8vBYHykKEWBPLiitzDzGaAl0xkVlKNDkfmIDySuINjc2MLExNTI2NzC3N
	lMR5daR/BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgnHbNP/+tlNlnsbCsKGW+NgPHZ/Z7
	J02ZzOPvcELyj+zu6Buf5Zd8Us+ROCarMn+eyUGuacwNvF/+tJmorJvy0OPEq7QV6xT0Nmjf
	q9/+7KwOyw6RrJfVllHJWW0eN70u7VaPuut+wkwmeOOOl08fzb4fyHnuTO+mxAqNNzzl/I98
	g8Umb1+4QomlOCPRUIu5qDgRAGB9YiMIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAd0mzvIQg9vdGhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWU/4sZ7LY9Pgaq8Xl
	XXPYLGac38dksfT6RSaLU9c/s1kcftPOajFj8ks2i2MzljBarNr1h9Hi5ccTLA6iHmvmrWH0
	+P1rEqPHzll32T3uXNvD5rF5Sb3HlRNNrB59W1YxenzeJBfAEdXAaJORmpiSWqSQmpecn5KZ
	l26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JqSQlliTilQKCCxuFhJ3w7ThNAQ
	N10LmMYIXd+QILgeIwM0kLCGMWPu1YWsBWfZKm58lW1gnMfaxcjJISFgIrF37jEWCFtM4sK9
	9WxdjFwcQgKLGCU6V2xignBeM0osfHSeGaSKV0BLYu35H0wgNouAqsTGtx1gcTag+P4XN9hA
	bFGBMImV06+wQNQLSvyYfA/MFhHQlbjQNgXMZhbYwiGxf7sTiC0sECnxffcNdohluxklXu/v
	BRrKwcEp4CzR/1cWol5HYn/rNDYIW15i85q3zBMYBWYhWTELSdksJGULGJlXMYqmFiQXFCel
	5xrqFSfmFpfmpesl5+duYgSnnmdSOxhXNlgcYhTgYFTi4bU4UBYixJpYVlyZe4hRgoNZSYSX
	i7E8RIg3JbGyKrUoP76oNCe1+BCjKTAEJjJLiSbnA9NiXkm8obGJmZGlkbmhhZGxuZI4742b
	uSFCAumJJanZqakFqUUwfUwcnFINjCsOPl+UmVC67HwWw5Tcw1fPFvIsU2RutfjHYvcsk03v
	tcflO/YdmUuzzj9gXvXEc2JEpvW0/PeKAhv+f7yw7Fnyypm8b/blzY+Zpb239FOx07Zr1Wk3
	4zzqlixx8n0cvUqPS7P2TpsC1zTP9/YRXktuiwZqfbBKvDL3idrre6Eznis4GUaZOCixFGck
	GmoxFxUnAgD05UrpUwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 08:18 PM, Catalin Marinas wrote:
> On Thu, Nov 27, 2014 at 07:35:12AM +0000, Chanwoo Choi wrote:
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index f4536e0..8a5e8a0 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -152,6 +152,16 @@ config ARCH_EXYNOS
>>  	help
>>  	  This enables support for Samsung Exynos SoC family
>>  
>> +config ARCH_EXYNOS5433
>> +	bool "ARMv8 based Samsung Exynos5433"
>> +	select ARCH_EXYNOS
>> +	select COMMON_CLK_SAMSUNG
>> +	select PINCTRL
>> +	select PINCTRL_EXYNOS
>> +
>> +	help
>> +	  This enables support for Samsung Exynos5433 SoC family
> 
> Please update defconfig as well to include this. We aim for the
> arm64 defconfig to build all the supported SoCs.
> 

OK, I'll add it.

Thanks for your review.

Best Regards,
Chanwoo Choi
