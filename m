Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaGJNaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:30:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8690 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaGJNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:30:07 -0400
X-AuditID: cbfee68f-b7fef6d000003970-59-53be955d3189
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
Cc: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-7-git-send-email-t.figa@samsung.com>
 <038b01cf9ab7$0de5a440$29b0ecc0$@samsung.com> <156099171.AcKbd1QIut@amdc1032>
In-reply-to: <156099171.AcKbd1QIut@amdc1032>
Subject: RE: [PATCH 6/6] ARM: EXYNOS: Register cpuidle device only on
 Exynos4210 and 5250
Date: Thu, 10 Jul 2014 22:30:05 +0900
Message-id: <026601cf9c43$0faf6ad0$2f0e4070$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQImwlMNtKSRmS2HaaYx0l+evMEXagHXA9bPAkXHzUQB7xlvpJq6og/Q
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zfd3YqfuCDQ5vVLTYOGM9q8Wmx9dY
	LS7vmsNmMeP8PiaLtUfuslusn/GaxWLVrj+MDuweO2fdZffYvKTeo2/LKkaPz5vkAliiuGxS
	UnMyy1KL9O0SuDK6mr+xFJzlrrg8aRpjA+MEzi5GTg4JAROJmZuXMELYYhIX7q1n62Lk4hAS
	WMYosfnHdRaYop6ucywQiemMEnsuLWaHcP4ySsx40wxWxSagIXH4/TN2EFtEwEri8YyzYEXM
	Ai8ZJb78+8UI0XGaUWLmsW9gHZwCOhINU46CdQgLREtseT+JGcRmEVCVuPOrGSjOwcErYCmx
	utUeJMwrICjxY/I9sFZmAS2J9TuPM0HY8hKb17xlhjhVQWLH2deMEHERiX0v3jFCHOQmcXXP
	a7AXJAQesUs8XPsTapeAxLfJh1hAdkkIyEpsOgA1R1Li4IobLBMYJWYhWT0LyepZSFbPQrJu
	ASPLKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYyQuO3fwXj3gPUhxmSg9ROZpUST84Fxn1cS
	b2hsZmRhamJqbGRuaUaasJI47/2HSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGNenHXTi
	niw/3636/TXvor3PtLsuCnZMdPloGdC1PuvJfS2F/d32+0Jf9J+f51v47cQvE+e++EjGOXWu
	AjFz81ya65pWxKnmePD3vSv9qvzOVi051eN3k4bAfvNfcy51Opb2b1xrc3ppqty/ifmX1j5R
	LP2YqS12ntHw2r1/vReWbXsy/+wJViWW4oxEQy3mouJEACvIaMzxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoG7s1H3BBhPPyFpsnLGe1WLT42us
	Fpd3zWGzmHF+H5PF2iN32S3Wz3jNYrFq1x9GB3aPnbPusntsXlLv0bdlFaPH501yASxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzupq/sRSc5a64PGkaYwPjBM4uRk4O
	CQETiZ6ucywQtpjEhXvr2boYuTiEBKYzSuy5tJgdwvnLKDHjTTNYFZuAhsTh98/YQWwRASuJ
	xzPOghUxC7xklPjy7xcjRMdpRomZx76BdXAK6Eg0TDkK1iEsEC2x5f0kZhCbRUBV4s6vZqA4
	BwevgKXE6lZ7kDCvgKDEj8n3wFqZBbQk1u88zgRhy0tsXvOWGeJUBYkdZ18zQsRFJPa9eMcI
	cZCbxNU9r1kmMArNQjJqFpJRs5CMmoWkfQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M
	4KTwTGoH48oGi0OMAhyMSjy8DT17g4VYE8uKK3MPMUpwMCuJ8GbV7QsW4k1JrKxKLcqPLyrN
	SS0+xGgK9OhEZinR5HxgwsoriTc0NjEzsjQyszAyMTdXEuc90GodKCSQnliSmp2aWpBaBNPH
	xMEp1cB4dHGhVv7Gm34cW/rf9AWWVmZ+Pf724e107TnWxlEyjHb9E/qXXtv3o6c15W3J60Wl
	e5clCV9c2WjZsPvH2Z4rfP8Z4vee74wtMH3dmMf99dSkbtOQ1IrNblcN/T1sH6SoF81hbjok
	t2ff6oCQhVfN/yXWpV6J2V/+L8SP51jrS76wZtkDby8psRRnJBpqMRcVJwIAdL8obiADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
Hi Bart,

> On Tuesday, July 08, 2014 11:15:21 PM Kukjin Kim wrote:
> > Tomasz Figa wrote:
> > >
> > > Currently, the Exynos cpuidle driver works correctly only on Exynos4210
> > > and 5250. Trying to use it with just one CPU online on any other Exynos
> > > SoC will lead to system failure, due to unsupported AFTR mode on other
> > > SoCs. This patch fixes the problem by registering the driver only on
> > > supported SoCs and letting others simply use default WFI mode until
> > > support for them is added.
> > >
> > Hmm...I thought other SoCs have no problem on cpuidle except exynos5420 and
> > exynos5440....something like this would be helpful to avoid system failure.
> > But unfortunately this conflicts with Pankaj's cleanup cpufreq_init() and
> > cpuidle_init() patch you've reviewed and I've applied in my local...
> >
> > I'm going to check which exynos is ok on cpuidle and then sort them out.
> 
> Tomasz's patch is correct - currently only Exynos4210 and Exynos5250 work
> fine with AFTR mode and upstream kernel (AFTR gets triggered by offlining
> CPUs other than CPU0).
> 
> [ Exynos4x12 and Exynos3250 need secure firmware support (patches for this
>   need to be reworked on top of recent PM/firmware/cpuidle changes).
> 
>   Exynos5410 should use big_little cpuidle driver. ]
> 
Agreed that this is required at this moment.
I will take this into fixes for 3.16.

Thanks,
Kukjin

