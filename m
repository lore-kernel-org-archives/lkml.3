Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaFYE3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:29:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10577 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaFYE3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:29:46 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-74-53aa5037511b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: vikas.sajjan@samsung.com, chow.kim@samsung.com, kgene.kim@samsung.com,
        linux@arm.linux.org.uk
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-11-git-send-email-pankaj.dubey@samsung.com>
 <53A07719.7050206@samsung.com> <007a01cf8f9f$7909c850$6b1d58f0$@samsung.com>
 <53AA13BD.9060800@gmail.com>
In-reply-to: <53AA13BD.9060800@gmail.com>
Subject: RE: [PATCH v4 10/11] ARM: EXYNOS: Add platform driver support for
 Exynos PMU.
Date: Wed, 25 Jun 2014 10:00:59 +0530
Message-id: <000101cf902e$452790f0$cf76b2d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFbr3MzJH2VQYc81U++V3sC+P5mXwHxSbcIAc57yfUCZOxE5wJmZCd8nCSe/VA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkStc8YFWwwYXT/BbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wW62e8ZrFYtesPo8XNZ9uZHDg9Wpp72Dx2zrrL7rF5Sb1H
	35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZczZb1NwWKzi3/rr7A2M2wW7GDk5JARMJO5cOcYM
	YYtJXLi3nq2LkYtDSGApo0TT8l5GmKJLV1ZAJRYxSly98ZkFwvnLKLH71h5WkCo2AV2JJ+/n
	MoMkRAR2MEp8ufYGqJ2Dg1kgWWLW1USIhm+MEs1zD4ON5RTQlHi1vwPMFhaIkNj86RQLiM0i
	oCpxsGE7G4jNK2ApsfRQDyOELSjxY/I9sBpmAS2J9TuPM0HY8hKb17yF+kFBYsfZ12D1IgJ+
	Evt3dTBD1IhLTHrwkB3kCAmBn+wSf7+tYIRYJiDxbfIhFpBDJQRkJTYdgJojKXFwxQ2WCYwS
	s5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmBEn/73rG8H480D
	1ocYk4HWT2SWEk3OByaEvJJ4Q2MzIwtTE1NjI3NLM9KElcR5Fz1MChISSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAWH5yj7rzvwOR+c84fA/Jiss2yiuskvSdbL6dh0X+vdC8i4yyBdKmLBo9
	57///sq4y0pI9t2iRKaIOX6Pctk3vp28fFp294xurUXe7PNOMlke3aUYL8OTK7KP57e82qWc
	zClml9pV59+ceTfQVKHk9put9TMarTe+fHTFUEWlxGrxadmFHMblSizFGYmGWsxFxYkAIgPB
	V/4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAV3zgFXBBm/Xs1ssm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NarJ/xmsVi1a4/jBY3n21ncuD0aGnuYfPYOesuu8fmJfUe
	fVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjzn6bgsNi
	Ff/WX2dvYNwu2MXIySEhYCJx6coKNghbTOLCvfVANheHkMAiRomrNz6zQDh/GSV239rDClLF
	JqAr8eT9XGaQhIjADkaJL9feMHYxcnAwCyRLzLqaCNHwjVGiee5hRpAGTgFNiVf7O8BsYYEI
	ic2fTrGA2CwCqhIHG7aDreYVsJRYeqiHEcIWlPgx+R5YDbOAlsT6nceZIGx5ic1r3jJDnKog
	sePsa7B6EQE/if27OpghasQlJj14yD6BUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEp4tn0jsYVzVYHGIU4GBU4uG9MHtlsBBrYllxZe4hRgkOZiUR3kte
	q4KFeFMSK6tSi/Lji0pzUosPMZoCfTqRWUo0OR+YyvJK4g2NTcxNjU0tTSxMzCyVxHkPtloH
	CgmkJ5akZqemFqQWwfQxcXBKNTC6NL5qX8nq98PEiUf8n2D0B8F97KZply+fuLZmiuKBKP4d
	pjfeHP6/+tCcx6wbOM7Mt7gq4Cn6dutn8S7fefdq9GNaE0725C3RNwxbEvDfxaPq0K+E8rAl
	NyUn23kkfDDhFSp4v+Xu8bTjLzf6pny/PJfxQvHyB5oe/v9VE6WXF9rKS91xulijxFKckWio
	xVxUnAgAwjvgvS0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, June 25 2014 Tomasz Figa write:
> On 24.06.2014 13:28, Pankaj Dubey wrote:
> > On Tuesday, June 17 2014, Tomasz Figa wrote:
> >> On 10.05.2014 08:56, Pankaj Dubey wrote:
> 
> [snip]
> 
> >>> +
> >>> +	ret = platform_driver_register(&exynos_pmu_driver);
> >>> +	if (ret < 0)
> >>> +		goto out;
> >>> +
> >>> +	exynos_pmu_pdev = platform_device_register_simple("exynos-pmu",
> -1,
> >>> +			NULL, 0);
> >>
> >> Hmm, I don't see the point of making this a platform driver only to
> > register respective
> >> platform device few lines below. If you take into account the patch
> >> for
> > syscon I
> >> posted as a reply to patch 06/11, you will be able to make this a
> >> normal
> > platform
> >> driver that binds to DT node directly and then register a syscon in
> >> probe
> > function
> >> above.
> >>
> >
> > Well I updated PMU to be a syscon provider using your patch. It worked
well.
> > I have following two points to mention here:
> >
> > 1: For making PMU a normal platform driver, other than making PMU a
> > syscon provider we need to change PMU's DT binding. Basically we need
> > to remove "syscon"
> > as second compatibility string. I hope this should not be an issue.
> 
> I don't see the reason for this. Could you elaborate on this?
> 

Currently syscon driver is registered via postcore_initcall whereas exynos
pmu has
arch_initcall. So if we keep syscon as second compatibility in exynos pmu
node,
syscon will be registered first and hence only syscon will be probed.

> I know that the way Linux currently handles multiple compatible strings is
broken,
> but despite this, if you just make sure your platform driver registers
before syscon
> platform driver, it should be fine.
>

Yes, this could be possible if I convert arch_initcall of exynos pmu to
postcore_initcall.

As after converting arch_initcall to postcore_initcall, syscon driver will
not be probed
for exynos pmu node. Also as exynos pmu driver will now register itself as
syscon provider,
I could not see any use of keeping second compatibility as "syscon" in
exynos pmu
node.  Do you think it is still required?

After removing "syscon" compatibility string from exynos pmu node, I have
tested
S2R as well as watchdog driver functionality, which is user of regmap handle
of exynos pmu
and both are working fine on exynos5250.
 
> >
> > 2: I can see for your syscon patch Arnd has some comments, hopefully
> > we can address his concern.
> >
> 
> Yes. I will get to it after sorting out few other things from my queue.
> Or you can do it if you want - the purpose of that RFC patch was just to
> show the idea I had in my mind.
> 

OK, let me post exynos pmu v5, based on your patch, and then if time permits
I will have a look in it.

> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

