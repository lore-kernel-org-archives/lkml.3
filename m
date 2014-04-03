Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaDCCMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 22:12:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61137 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbaDCCMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 22:12:12 -0400
X-AuditID: cbfee68f-b7f156d00000276c-71-533cc37b30f5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Pankaj Dubey'" <pankaj.dubey@samsung.com>, monstr@monstr.eu
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        chow.kim@samsung.com
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-3-git-send-email-pankaj.dubey@samsung.com>
 <533BFC31.1080203@monstr.eu> <533CBC18.8050106@samsung.com>
In-reply-to: <533CBC18.8050106@samsung.com>
Subject: RE: [PATCH 02/10] ARM: EXYNOS: Correct file path in comment message
Date: Thu, 03 Apr 2014 11:12:08 +0900
Message-id: <00f301cf4ee2$1f2445c0$5d6cd140$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEcUoZuZz85M0GdUsocYYERgqrHUAGddHyMAlEclIcCjq07p5wxNKTg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zQ93qwzbBBqvOy1gsm3SXzWLT42us
	Fpd3zWGzmHF+H5PF7cu8Fk8+nmaxWLT1C7sDu0dLcw+bx+Yl9R5/u6Ywe/RtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGgbYtbAVvuSqObr3B3MB4nqOLkZNDQsBE4s2xjWwQtpjEhXvrgWwu
	DiGBZYwSDz72ssEUfX39khEisYhRYmH/FnYI5y+jxONHu5lBqtgENCQOv3/GDmKLCNhL9E74
	wAxSxCwwk1Fi8tEWqLmHGSXW7FnMClLFKaAtce3gFUYQW1jAR2L77CtgcRYBVYkpkyaC7eYV
	sJT4cfkqlC0o8WPyPRYQm1lAXWLSvEXMELa8xOY1b5khblWQ2HH2NSPEFW4S30/8gqoRkdj3
	4h0jRM1LdonHH8ogdglIfJt8CGgmB1BcVmLTAagxkhIHV9xgmcAoMQvJ5llINs9CsnkWkg0L
	GFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoTEb/8OxrsHrA8xJgOtn8gsJZqcD4z/vJJ4
	Q2MzIwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOHfLv2Jv
	tVf9YROmnYhQ+/F4mWZHp7zCQkmn7IRV/ow3ti4scd3A+anx+660JW6+Bw5/yTfO97g4WcdY
	5KG9v/dEsRW1tY93i7WsCn4eVdYU8ePxqTn2/8yX2x92j9sZo7nIgO2Fu5SniZJyhGH+JI93
	k+fdqzmf+vHhZ6anDX0eF1XD2FbPVWIpzkg01GIuKk4EADx7LsX1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAd3qwzbBBkvWSFgsm3SXzWLT42us
	Fpd3zWGzmHF+H5PF7cu8Fk8+nmaxWLT1C7sDu0dLcw+bx+Yl9R5/u6Ywe/RtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjANtW9gK3nJVHN16g7mB8TxH
	FyMnh4SAicTX1y8ZIWwxiQv31rN1MXJxCAksYpRY2L+FHcL5yyjx+NFuZpAqNgENicPvn7GD
	2CIC9hK9Ez4wgxQxC8xklJh8tAWq/TCjxJo9i1lBqjgFtCWuHbwCtkNYwEdi++wrYHEWAVWJ
	KZMmsoHYvAKWEj8uX4WyBSV+TL7HAmIzC6hLTJq3iBnClpfYvOYtM8StChI7zr5mhLjCTeL7
	iV9QNSIS+168Y5zAKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGC08MzqR2MKxssDjEKcDAq8fBaSNkEC7EmlhVX5h5ilOBgVhLhddkHFOJNSaysSi3Kjy8q
	zUktPsSYDPTpRGYp0eR8YOrKK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFq
	EcwWJg5OqQbGwKS/gq/CBV2vVFX4fXxywfrgh00X94dLlBlvs/z2buobqcUH1wq7ncnbzZZU
	ZSoou2eWq7mD9ivzwwcMtxR0TqhdUdJUwaw1u2NB0/tadu74Z5Kpyu8fpneX37z4R2NzrGH7
	g18rX997e+bz913pEkovg6vT80Nr9E7v1jwm5fdgqejCTh95JZbijERDLeai4kQAK8V9a1MD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pankaj Dubey wrote:
> 
> Hi Michal,
> 
> On 04/02/2014 09:01 PM, Michal Simek wrote:
> > On 04/02/2014 09:50 AM, Pankaj Dubey wrote:
> >> This patch corrects file path mentioned in file comment message.
> >>
> >> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> >> ---
> >>   arch/arm/mach-exynos/platsmp.c |    2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-
> exynos/platsmp.c
> >> index 03e5e9f..d8d1555 100644
> >> --- a/arch/arm/mach-exynos/platsmp.c
> >> +++ b/arch/arm/mach-exynos/platsmp.c
> >> @@ -1,4 +1,4 @@
> >> -/* linux/arch/arm/mach-exynos4/platsmp.c
> >> +/* linux/arch/arm/mach-exynos/platsmp.c
> >>    *
> >>    * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >>    *		http://www.samsung.com
> >>
> > Shouldn't you just remove it entirely?
> > I had the same file names in the whole microblaze tree
> > and some months/years later this was just broken everywhere.
> > That's why it is just easier to remove it entirely.
> 
> Thanks for review and suggestion.
> Removing of file name makes more sense to me also.
> Will take care of this in some other files also under "mach-exynos"
> in next version of patch.
> 
No, basically don't need it.

And Sachin/Tushar have posted it before, I didn't agree at that time though.

- Kukjin

