Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbaGRFMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:12:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28041 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbaGRFMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:12:33 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-3e-53c8acbe7a01
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Jonathan Cameron'" <jic23@kernel.org>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>, ch.naveen@samsung.com,
        t.figa@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
 <53AFFD69.8060702@kernel.org>
In-reply-to: <53AFFD69.8060702@kernel.org>
Subject: RE: [PATCHv5 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
Date: Fri, 18 Jul 2014 14:12:27 +0900
Message-id: <005701cfa246$df97ed40$9ec7c7c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHF+bTdfL8i66mfleMRAwAuQuVWhQFw+Awvm60R/2A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t8zQ919a04EGxzawmdx9/lhRovrX56z
	Wsw/co7Vov/NQlaLc69WMlo8aFrFZHG26Q27xbwj71gsLu+aw2Yx4/w+Joul1y8yWUyYvpbF
	4u2d6SwWrXuPsFuc/NPLaLF+xmsWBwGPNfPWMHpc7utl8li5/Aubx+YVWh6bVnWyedy5tofN
	o2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDLWtM9gK3jAX9HevJqxgXEWTxcjJ4eEgInEvl8T
	2SBsMYkL99YD2VwcQgLLGCXeNf9khSk6//I6K0RiEaPEgzUt7BDOX0aJdev/MoNUsQloSBx+
	/wwsISLQwCjxbfJusFnMAgeYJOa9O8vUxcgB1JIq0bfJAKSBU0BL4tGFuWArhAUiJKa+vMcO
	YrMIqEq8f3OaCcTmFbCUOLfwESuELSjxY/I9FhCbGah3/c7jTBC2vMTmNW+ZIU5VkNhx9jUj
	iC0iYCUxu6eXDaJGRGLfi3eMIPdICBzhkJh+7j4TxDIBoEMPsYDcJiEgK7HpANQcSYmDK26w
	TGCUmIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MUISR98OxpsH
	rA8xJgOtn8gsJZqcD0w8eSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBcdI9kc2XF+cclsg7/ejI6db/z7hMVyvzBzuYF4bKXDab8lPrPffN5Uk7
	L8y7uP/qqR09ISW3pNfs3MXecHKfeNejxluTxEOThdMvnor0mseqX6C7ZPFZf7m4W5P7VTIl
	4hTSvQ9zhz4791R86tKLe/M3Pnz6jfn5BsuwvOVXq90u9b/w/bT6YY0SS3FGoqEWc1FxIgA2
	sP8DMgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAd19a04EG8zp5LS4+/wwo8X1L89Z
	LeYfOcdq0f9mIavFuVcrGS0eNK1isjjb9IbdYt6RdywWl3fNYbOYcX4fk8XS6xeZLCZMX8ti
	8fbOdBaL1r1H2C1O/ulltFg/4zWLg4DHmnlrGD0u9/Uyeaxc/oXNY/MKLY9NqzrZPO5c28Pm
	0bdlFaPH501yARxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZK
	Lj4Bum6ZOUAvKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz1rTPYCt4
	wF/R3ryasYFxFk8XIyeHhICJxPmX11khbDGJC/fWs3UxcnEICSxilHiwpoUdwvnLKLFu/V9m
	kCo2AQ2Jw++fgSVEBBoYJb5N3g3WwixwgEli3ruzTF2MHEAtqRJ9mwxAGjgFtCQeXZgLtkJY
	IEJi6st77CA2i4CqxPs3p5lAbF4BS4lzCx+xQtiCEj8m32MBsZmBetfvPM4EYctLbF7zlhni
	VAWJHWdfM4LYIgJWErN7etkgakQk9r14xziBUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEp6Vn0jsYVzVYHGIU4GBU4uG1uHk8WIg1say4MvcQowQHs5II
	b/Z9oBBvSmJlVWpRfnxRaU5q8SFGU6BPJzJLiSbnA1NmXkm8obGJmZGlkZmFkYm5uZI478FW
	60AhgfTEktTs1NSC1CKYPiYOTqkGxvyNXW/VS5+z3ouSqHr37V+4dvcTxiMibnkr37GVZk7h
	FjerzJRYbJXsMdXVZvfGEoNfzq+rFTz398uYdpfOz432t0hfKLH3k0rhywCuR4Fn50QF/5iv
	Z9zv/yUzIPbBsm5ml/XW0c9E5DXNYxS7HU6ZlSTuLKxqLWJ4+OIvv+rtjb/OtPUosRRnJBpq
	MRcVJwIATcQAl2EDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron wrote:
> 
> On 27/06/14 05:30, Chanwoo Choi wrote:
> > Changes from v4:
> > - Use 'exynos_adc_data' structure instead of 'exynos_adc_ops' structure
> >    and remove enum variable of ADC version
> > - Fix wrong name of special clock (sclk_tsadc -> sclk_adc)
> > - Add reviewed message by Naveen Krishna Chatradhi
> > - Add functions for ADC clock control
> >
> > Changes from v3:
> > - Add new 'exynos_adc_ops' structure to improve readability according to
> >   Tomasz Figa comment[1]
> >   [1] https://lkml.org/lkml/2014/4/16/238
> > - Add new 'exynos3250-adc-v2' compatible string to support Exynos3250 ADC
> > - Fix wrong compaitlbe string of ADC in Exynos3250 dtsi file
> >
> > Changes from v2:
> > - Check return value of clock function to deal with error exception
> > - Fix minor coding style to improve readability
> >
> > Changes from v1:
> > - Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
> > - Add a patch about DT binding documentation
> >
> > Chanwoo Choi (4):
> >    iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
> >    iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
> >    iio: devicetree: Add DT binding documentation for Exynos3250 ADC
> >    ARM: dts: Fix wrong compatible string for Exynos3250 ADC
> >
> >   .../devicetree/bindings/arm/samsung/exynos-adc.txt |  26 +-
> >   arch/arm/boot/dts/exynos3250.dtsi                  |   4 +-
> >   drivers/iio/adc/exynos_adc.c                       | 326 +++++++++++++++------
> >   3 files changed, 268 insertions(+), 88 deletions(-)
> >
> I am happy with this series, but given it touches some exynos bindings, I would
> like an ack from Kukjin Kim (or according to MAINTAINERS Ben Dooks) before taking it
> all through IIO.
> 
Hi,

Sorry for late response...

The change looks good to me, so please go ahead with my ack on exynos stuff.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

