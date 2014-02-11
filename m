Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaBKDCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:02:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15200 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaBKDC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:02:27 -0500
X-AuditID: cbfee690-b7f266d00000287c-a3-52f992beb360
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Ralf Baechle'" <ralf@linux-mips.org>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Eric Miao'" <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-input@vger.kernel.org, linux-pwm@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>,
        "'Roland Stigge'" <stigge@antcom.de>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
In-reply-to: <003901cf25fc$73002790$590076b0$%han@samsung.com>
Subject: Re: [PATCH 0/7] Remove HAVE_PWM config option
Date: Tue, 11 Feb 2014 12:02:21 +0900
Message-id: <007801cf26d5$aeaf3040$0c0d90c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l/GYGhOsBgXmsQoSPhLhnprg0iAA2IYdQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t8zQ919k34GGZw8xWrxd9IxdovDi14w
	WuxoO85mcXnhJVaLKX+WM1lsenyN1eLmp2+sFpd3zWGzmDB1ErvF3burGC1uX+a1uLRHxeLv
	9k0sFpOXnGW1+LlrHosDv8ecqbsZPVqae9g8fv+axOixc9Zddo871/aweRxduZbJY/OSeo/+
	vwYefVtWMXp83iQXwBXFZZOSmpNZllqkb5fAlXG8cyVjwXPhipenTzM3MPbxdzFyckgImEh0
	Ht/FCmGLSVy4t56ti5GLQ0hgGaPEwZ/zGWGKvt06yA6RWMQocffzOhYI5xejxKVZ28Gq2ATU
	JL58OQxWJSKwklHiycurbCAJZoE5zBKbvySD2EICthJzG/azg9icAnYS85Z+A9stLGAmsbj7
	Flg9i4CqxMn1z8DivED1/f9Ps0PYghI/Jt9jgZipJbF+53EmCFteYvOat8xdjBxAp6pLPPqr
	CxIWETCSuPP9KzNEiYjEvhfvGEFukxA4wyGx6OwfFohdAhLfJh9igeiVldh0gBniY0mJgytu
	sExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFCUseEHYz3
	DlgfYkwGWj+RWUo0OR+YevJK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQkJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgTHKQFdopvEzrg9nfy+p+t+3NvFF585vEs6F8sxPP6vpvpi/Q9Lg9t3J
	Up+iuB/kHbebczFszbQl6vs1ag56ZyY92LeH94HWByHHjCkifw0uPbnL3O1rkm8dMeWlnc/C
	ojnTVGdpCKyrXNXnsMKoa4N/Rpfi01zzxf3Htkz/Errglc4ZNk+pmPVKLMUZiYZazEXFiQDY
	fJRoMwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsVy+t9jAd29k34GGey7Y2Pxd9IxdovDi14w
	WuxoO85mcXnhJVaLKX+WM1lsenyN1eLmp2+sFpd3zWGzmDB1ErvF3burGC1uX+a1uLRHxeLv
	9k0sFpOXnGW1+LlrHosDv8ecqbsZPVqae9g8fv+axOixc9Zddo871/aweRxduZbJY/OSeo/+
	vwYefVtWMXp83iQXwBXVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SEkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHjeOdK
	xoLnwhUvT59mbmDs4+9i5OSQEDCR+HbrIDuELSZx4d56ti5GLg4hgUWMEnc/r2OBcH4xSlya
	tZ0RpIpNQE3iy5fD7CAJEYGVjBJPXl5lA0kwC8xhltj8JRnEFhKwlZjbsB9sLKeAncS8pd9Y
	QWxhATOJxd23wOpZBFQlTq5/BhbnBarv/3+aHcIWlPgx+R4LxEwtifU7jzNB2PISm9e8Ze5i
	5AA6VV3i0V9dkLCIgJHEne9fmSFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgQnpmdSOxhXNlgcYhTgYFTi4dX4+iNIiDWxrLgy9xCjBAez
	kgjvWbufQUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0yaeSXxhsYmZkaWRmYWRibm5qQJ
	K4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6OWw+frcbmcFJSe1HefNs2vUakuYPryUOh3R
	cLj+IMP6folzrbxfflZWhkZ6tv3xb1568vz7SiMjq59vXf6rHOh5IyvEbPvXLvuOeUd85Pwy
	TRaTPeeX/5sb53/buFXliFz5VXfeVG1J18lnPdUY/5xrPSO0Ydr6RdaHvsQ1L9BbGZsg8fyn
	EktxRqKhFnNRcSIAYX8WDJADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 10, 2014 10:07 AM, Jingoo Han wrote:
> 
> The HAVE_PWM symbol is only for legacy platforms that provide
> the PWM API without using the generic framework, while PWM symbol
> is used for PWM drivers using the generic PWM framework.
> 
> I looked at all HAVE_PWMs in the latest mainline kernel 3.14-rc1.
> Three platforms are still using HAVE_PWM as below:
> 
> 1. ARM - PXA
>   ./arch/arm/mach-pxa/Kconfig
> 
> 2. ARM - NXP LPC32XX
>   ./arch/arm/Kconfig
>   config ARCH_LPC32XX
>   	select HAVE_PWM
> 
> 3. MIPS - Ingenic JZ4740 based machines
>   ./arch/mips/Kconfig
>   config MACH_JZ4740
>   	select HAVE_PWM
> 
> However, the legacy PWM drivers for PXA, LPC32XX, and JZ474 were
> already moved to the generic PWM framework.
>   ./drivers/pwm/pwm-pxa.c
>   ./drivers/pwm/pwm-lpc32xx.c
>   ./drivers/pwm/pwm-jz4740.c
> 
> In conclusion, HAVE_PWM should be removed, because HAVE_PWM is
> NOT required anymore.
> 
> Jingoo Han (7):
>       ARM: pxa: don't select HAVE_PWM
>       ARM: lpc32xx: don't select HAVE_PWM
>       ARM: remove HAVE_PWM config option
>       MIPS: jz4740: don't select HAVE_PWM
>       Input: max8997_haptic: remove HAVE_PWM dependencies
>       Input: pwm-beepe: remove HAVE_PWM dependencies
>       pwm: don't use IS_ENABLED(CONFIG_HAVE_PWM)
> 
>  arch/arm/Kconfig           |    4 ----
>  arch/arm/mach-pxa/Kconfig  |   15 ---------------
>  arch/mips/Kconfig          |    1 -
>  drivers/input/misc/Kconfig |    4 ++--
>  include/linux/pwm.h        |    2 +-
>  5 files changed, 3 insertions(+), 23 deletions(-)

(+cc Sascha Hauer, Roland Stigge)

The same patch was already submitted by Sascha Hauer. [1]
So, please ignore this patch. Thank you.

[1] https://lkml.org/lkml/2014/1/16/262

Best regards,
Jingoo Han

> 
> I would like to merge these patches as below:
> 
> 1. Through arm-soc tree
>   [PATCH 1/7] ARM: pxa: don't select HAVE_PWM
>   [PATCH 2/7] ARM: lpc32xx: don't select HAVE_PWM
>   [PATCH 3/7] ARM: remove HAVE_PWM config option
> 
> 2. Through MIPS tree
>   [PATCH 4/7] MIPS: jz4740: don't select HAVE_PWM
> 
> 3. Through Input tree
>   [PATCH 5/7] Input: max8997_haptic: remove HAVE_PWM dependencies
>   [PATCH 6/7] Input: pwm-beepe: remove HAVE_PWM dependencies
> 
> 4. Through PWM tree
>   [PATCH 7/7] pwm: don't use IS_ENABLED(CONFIG_HAVE_PWM)
> 
> After merging these patches, all HAVE_PWM will be removed from
> the mainline kernel. Thank you. :-)
> 
> Best regards,
> Jingoo Han

