Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbaEEJKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:10:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24919 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbaEEJKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:10:37 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-e4-5367558c4663
Message-id: <536759D1.4000001@samsung.com>
Date: Mon, 05 May 2014 18:28:49 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, Arnd Bergmann <arnd@arndb.de>,
        t.figa@samsung.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/4] misc: exynos-chipid: Add Exynos Chipid driver support
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
 <1399097500-4052-4-git-send-email-pankaj.dubey@samsung.com>
 <1399276631.15737.1.camel@AMDC1943>
In-reply-to: <1399276631.15737.1.camel@AMDC1943>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY92e0PRgg3svRC3+TjrGbtG8eD2b
	xesXhha9C66yWWx6fI3V4vKuOWwWM87vY7K4fZnXYv2M1ywOnB4tzT1sHr9/TWL02D93DbvH
	5iX1Hn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJVxfNF/5oJ77BUbL/9lamCcz9bFyMkhIWAi
	sbX1PiuELSZx4d56oDgXh5DAMkaJ9nufmGCKZkzoBCsSEpjOKPF5BQtE0WtGiZMrZoFN4hXQ
	krj0fxFjFyMHB4uAqkTH+liQMJuArsST93OZQWxRgTCJTdP7WCHKBSV+TL7HAmKLCBhKHNy9
	nQlkJrNAE5PEpTtbwBYLC/hJnJ41mR1i2WpGidYdf8EmcQoYSFw58pMdxGYWMJN41LKOGcKW
	l9i85i0zSIOEwEt2ia27ZoJdxyIgIPFt8iEWkOskBGQlNh1ghvhMUuLgihssExjFZiE5ahaS
	sbOQjF3AyLyKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyQi+3cw3j1gfYgxGWjlRGYp0eR8
	YETnlcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	rV7+nNbfH63JeuhTXCL4XCryYf735IKnh9a/+HkhMDx01+xHIh3hV3L3fGNVCyk443m/y8V+
	pvzkraWeQSdn2HkVz0tsl39Qljt71l3pHJf1D6+I/uy7Or2nVW2inM1a7Wc7Qs1/rOJj3fDU
	IYs9+tUhuRr16ZWrPtm7LvAS7v+YMFn+fGWxEktxRqKhFnNRcSIALQXUjN4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd2e0PRgg/krBS3+TjrGbtG8eD2b
	xesXhha9C66yWWx6fI3V4vKuOWwWM87vY7K4fZnXYv2M1ywOnB4tzT1sHr9/TWL02D93DbvH
	5iX1Hn1bVjF6fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeY
	m2qr5OIToOuWmQN0k5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/ii
	/8wF99grNl7+y9TAOJ+ti5GTQ0LARGLGhE5WCFtM4sK99WBxIYHpjBKfV7B0MXIB2a8ZJU6u
	mAWW4BXQkrj0fxFjFyMHB4uAqkTH+liQMJuArsST93OZQWxRgTCJTdP7WCHKBSV+TL7HAmKL
	CBhKHNy9nQlkJrNAE5PEpTtbmEASwgJ+EqdnTWaHWLaaUaJ1x1+wSZwCBhJXjvxkB7GZBcwk
	HrWsY4aw5SU2r3nLPIFRYBaSJbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4m
	RnC8P5PewbiqweIQowAHoxIPbwJzerAQa2JZcWXuIUYJDmYlEd5ZjEAh3pTEyqrUovz4otKc
	1OJDjMnAIJjILCWanA9MRXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C
	2cLEwSnVwMhqcNHZW+Hmk8rjIt8+/Hv4Kahx5renC8t4Gdbv+nUmsie7P+rMukWvgpiixRof
	fQ5qqCp3W+tvdLfTYcP7V4ZTTy3bKTUlcM33iiAh6WebXDS6hXecPfC15nDtr4md3Mt1vU9p
	SvrYvbjHbv1qR8enE8vClmTurmP8fmP/pJezGXptLxmY7VJUYinOSDTUYi4qTgQAML5hUDsD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 04:57 PM, Krzysztof Kozlowski wrote:
> On sob, 2014-05-03 at 15:11 +0900, Pankaj Dubey wrote:
>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>> index 7eb4b69..48c8fb5 100644
>> --- a/drivers/misc/Makefile
>> +++ b/drivers/misc/Makefile
>> @@ -55,3 +55,4 @@ obj-$(CONFIG_SRAM)		+= sram.o
>>   obj-y				+= mic/
>>   obj-$(CONFIG_GENWQE)		+= genwqe/
>>   obj-$(CONFIG_ECHO)		+= echo/
>> +obj-$(CONFIG_EXYNOS_CHIPID)	+= exynos-chipid.o
>> diff --git a/drivers/misc/exynos-chipid.c b/drivers/misc/exynos-chipid.c
>> new file mode 100644
>> index 0000000..eb23339
>> --- /dev/null
>> +++ b/drivers/misc/exynos-chipid.c
>> @@ -0,0 +1,83 @@
>> +/*
>> + * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.
>> + *	      http://www.samsung.com/
> I wonder why this is copyrighted in the future (2015)?

Thanks for pointing out, will correct it in next version.

>
> Best regards,
> Krzysztof
>
>
>


-- 
Best Regards,
Pankaj Dubey

