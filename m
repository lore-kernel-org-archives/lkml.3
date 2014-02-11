Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaBKMSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:18:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:14792 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaBKMSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:18:01 -0500
X-AuditID: cbfee690-b7f266d00000287c-06-52fa14f751ff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Ralf Baechle'" <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
 <003d01cf25fd$309c58a0$91d509e0$%han@samsung.com> <52FA12B2.5090906@metafoo.de>
In-reply-to: <52FA12B2.5090906@metafoo.de>
Subject: Re: [PATCH 4/7] MIPS: jz4740: don't select HAVE_PWM
Date: Tue, 11 Feb 2014 21:17:59 +0900
Message-id: <000801cf2723$4d873940$e895abc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8nIe9YwZKKeTMzQweTKfLP6Xh3rwAASTfQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zI93vIr+CDG716VhcXniJ1WLJ5Pms
	Fpd3zWGzmDB1ErvFpT0qDqweR1euZfJY8uYQq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	/Hz7ialgLmfFnC0TGBsYF7J3MXJySAiYSEw8+pUZwhaTuHBvPVsXIxeHkMAyRomlf74xwxQ9
	XLaPHSKxiFHi7+HXUM4vRol9L9cyglSxCahJfPlyGGysiICWxNRvb1lBipgF2hkl5q9YwQLR
	0c8o8egASIaTgxOo6t65m2A7hAVsJPYsOsUEYrMIqEqsnD4DzOYVsJWYcuQsI4QtKPFj8j0W
	EJsZqHf9zuNMELa8xOY1b4HmcADdqi7x6K8uxBFGEnOmrGaGKBGR2PfiHSPEO9fYJVY9dYNY
	JSDxbfIhFohWWYlNB6A+lpQ4uOIGywRGiVlIFs9CsngWksWzkGxYwMiyilE0tSC5oDgpvchE
	rzgxt7g0L10vOT93EyMkQifsYLx3wPoQYzLQ+onMUqLJ+cAIzyuJNzQ2M7IwNTE1NjK3NCNN
	WEmcV+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpqID1uFr0300C+9NCk+MfvtMRb3
	yoOnzpYsargR0KmUXfuZcUPN6jmGD2dM2HRkkfyjSabvwhmvCq79e89mUnLY2k3SJaefhIYY
	VwUfcw87P+ux7+tber43ytp+hsefFem4csHvx89LOsbZv1X2bZrrLfLquNqrF6mBl7rqT900
	9Uk4l7Z26hIlluKMREMt5qLiRAAZLyfE5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAd3vIr+CDB5P17C4vPASq8WSyfNZ
	LS7vmsNmMWHqJHaLS3tUHFg9jq5cy+Sx5M0hVo++LasYPT5vkgtgiWpgtMlITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2qukUJaYUwoUCkgsLlbSt8M0
	ITTETdcCpjFC1zckCK7HyAANJKxjzPj59hNTwVzOijlbJjA2MC5k72Lk5JAQMJF4uGwflC0m
	ceHeerYuRi4OIYFFjBJ/D79mh3B+MUrse7mWEaSKTUBN4suXw2AdIgJaElO/vWUFKWIWaGeU
	mL9iBQtERz+jxKMDIBlODk6gqnvnbjKD2MICNhJ7Fp1iArFZBFQlVk6fAWbzCthKTDlylhHC
	FpT4MfkeC4jNDNS7fudxJghbXmLzmrdAcziAblWXePRXF+III4k5U1YzQ5SISOx78Y5xAqPQ
	LCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Az6R2MK5ssDjE
	KMDBqMTDq/H1R5AQa2JZcWXuIUYJDmYlEd4vwr+ChHhTEiurUovy44tKc1KLDzEmAz06kVlK
	NDkfmJzySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHRdsl7
	q+7+q5XFa7bv3P+5qPPL9fx5tptZBO5ZzX1jwaDWt2HxgvkNDEuUlyxdcnX5t4lFk84uuR3A
	pDZlax1jfc3doO0MMw/9LZulkuJ2PkBBUGXhq5YX/rM/HM4s/7d+xT3ePC3Tu3F7Kn+tTdCc
	5exoc2vxFpmL//6v8cuY83xb6qEHSzqlbZRYijMSDbWYi4oTAYhYf/FEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 11, 2014 9:08 PM, Lars-Peter Clausen wrote:
> On 02/10/2014 02:12 AM, Jingoo Han wrote:
> > The HAVE_PWM symbol is only for legacy platforms that provide
> > the PWM API without using the generic framework. The jz4740
> > platform uses the generic PWM framework, after the commit "f6b8a57
> > pwm: Add Ingenic JZ4740 support".
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Hi Lars-Peter Clausen,

I really appreciate your Acked-by. However, the same patch was
already submitted by Sascha Hauer.[1] So, please ignore this patch.
Thank you.

[1] https://lkml.org/lkml/2014/1/16/262

Best regards,
Jingoo Han

> 
> > ---
> >   arch/mips/Kconfig |    1 -
> >   1 file changed, 1 deletion(-)
> >
> > diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> > index dcae3a7..d132603 100644
> > --- a/arch/mips/Kconfig
> > +++ b/arch/mips/Kconfig
> > @@ -235,7 +235,6 @@ config MACH_JZ4740
> >   	select IRQ_CPU
> >   	select ARCH_REQUIRE_GPIOLIB
> >   	select SYS_HAS_EARLY_PRINTK
> > -	select HAVE_PWM
> >   	select HAVE_CLK
> >   	select GENERIC_IRQ_CHIP
> >
> >

