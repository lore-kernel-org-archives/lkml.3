Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaBGIbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:31:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41954 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaBGIbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:31:08 -0500
X-AuditID: cbfee690-b7f266d00000287c-41-52f499ca4447
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>
References: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
 <000701cf23da$688e1b60$39aa5220$%han@samsung.com> <52F495A4.70400@metafoo.de>
In-reply-to: <52F495A4.70400@metafoo.de>
Subject: Re: [PATCH 3/4] rtc: rtc-jz4740: Use devm_ioremap_resource()
Date: Fri, 07 Feb 2014 17:31:06 +0900
Message-id: <001801cf23de$f1b708d0$d5251a70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j3LMB8e5hdYe+SQOOT2rkAV/UAgAAPnTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zfd1TM78EGbRPMrRYcvEqu8Wc9WvY
	LC4vvMRqsWTyfFaLy7vmsFns7+xgtPi5ax6LA7vHzll32T32TDzJ5nFixm8WjyVvDrF69G1Z
	xegxfd5PJo/Pm+QC2KO4bFJSczLLUov07RK4MtZ8/s9YcImjYvHGPYwNjB/Yuhg5OSQETCSa
	NyxlgrDFJC7cWw8U5+IQEljGKLF71W8WmKKunSeYIRKLGCWm9G9nhXB+MUq8mnuFHaSKTUBN
	4suXw2C2iICWxNRvb8GKmAVeAo2aNBtqbi+jxI++TYwgVZwCGhIHJn5iBbGFBVwlFqxpZwax
	WQRUJfZuuAu2m1fAVuLbtrtsELagxI/J98DizEAb1u88zgRhy0tsXvMWqJcD6FZ1iUd/dSGO
	MJLY3HKTHaJERGLfi3eMIDdICPxkl7i4eAs7xC4BiW+TD7FA9MpKbDrADPGypMTBFTdYJjBK
	zEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCFxPWEH470D1ocY
	k4HWT2SWEk3OB6aFvJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgVL4Y8/LPme6+d2+3pDtrVKxm+d/EJrbmB3uOwiUTZs0QL2Njd7O/E760qr4o
	XR+r7fyT2+jR/Gn38nS4JP2mW/Zv25q5ZkXmLO0LXDP2/7lkeThtC4uYbb/YL/0/HGbT85Iu
	X1c7/LRWSmBxpavKC44l3mznP/0Ommay9tpjNZ/bUge3rdvSrcRSnJFoqMVcVJwIAAPthLUB	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAd1TM78EGTSe0bFYcvEqu8Wc9WvY
	LC4vvMRqsWTyfFaLy7vmsFns7+xgtPi5ax6LA7vHzll32T32TDzJ5nFixm8WjyVvDrF69G1Z
	xegxfd5PJo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNT
	bZVcfAJ03TJzgC5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWas+fyf
	seASR8XijXsYGxg/sHUxcnJICJhIdO08wQxhi0lcuLceKM7FISSwiFFiSv92VgjnF6PEq7lX
	2EGq2ATUJL58OQxmiwhoSUz99hasiFngJaPE7kmzodp7GSV+9G1iBKniFNCQODDxEyuILSzg
	KrFgTTvYPhYBVYm9G+6ygNi8ArYS37bdZYOwBSV+TL4HFmcG2rB+53EmCFteYvOat0C9HEC3
	qks8+qsLcYSRxOaWm+wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGCk8Yz6R2MqxosDjEKcDAq8fB2ApOJEGtiWXFl7iFGCQ5mJRHeyTOA
	QrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTGh5JfGGxiZmRpZGZhZGJubmpAkrifMebLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cDYetQv6oLGwVO+5yJC/5+M3PT+XJbv4rZ9Wc+XvXPI8sxW
	7FY25uiynePpH2w5U/Sko7Sja6f7+as3HVaZVB0yW6p5lkGK89s5/eCEzcHLVSVmn0qpNbxn
	Wbi6ObooK9fbiGEPn1Tpl7obfS9+rvM2eVn8sodbxHt70c/TvDuOvNuzKSZzTqESS3FGoqEW
	c1FxIgCOU/X8XgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 07, 2014 5:13 PM, Lars-Peter Clausen wrote:
> On 02/07/2014 08:58 AM, Jingoo Han wrote:
> [...]
> > -	rtc->base = devm_ioremap_nocache(&pdev->dev, rtc->mem->start,
> > -					resource_size(rtc->mem));
> > -	if (!rtc->base) {
> > -		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
> > -		return -EBUSY;
> > -	}
> > +	mem->flags &= ~IORESOURCE_CACHEABLE;
> 
> You shouldn't be modifying the resource, strictly speaking it is not owned
> by the device. And IORESOURCE_CACHEABLE is never set for this device anyway.

(+cc Thierry Reding)

Hi Lars-Peter Clausen,

Do you mean that resource's flags should NOT be modified by the
device driver, right?
Then, without 'mem->flags &= ~IORESOURCE_CACHEABLE', is it possible 
that devm_ioremap_nocache() can be called at devm_ioremap_resource()?

Thierry,
Do you have any comments on this?

Thank you.

Best regards,
Jingoo Han

> 
> > +	rtc->base = devm_ioremap_resource(&pdev->dev, mem);
> > +	if (IS_ERR(rtc->base))
> > +		return PTR_ERR(rtc->base);
> >
> >   	spin_lock_init(&rtc->lock);
> >
> >

