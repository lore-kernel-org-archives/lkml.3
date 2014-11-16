Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaKPBUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 20:20:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaKPBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 20:20:03 -0500
X-AuditID: cbfee68f-f791c6d000004834-14-5467fbc1636d
From: Kukjin Kim <kgene@kernel.org>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Cc: "'Olof Johansson'" <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, "'Mark Rutland'" <mark.rutland@arm.com>
References: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
 <54660DAE.9090601@samsung.com> <2593372.vOeyyAKq5M@wuerfel>
In-reply-to: <2593372.vOeyyAKq5M@wuerfel>
Subject: RE: [PATCH v8 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Sun, 16 Nov 2014 10:20:01 +0900
Message-id: <00ef01d0013b$716f1d30$544d5790$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQJVsPTjwpyq58svTs8V01DhuKvzYgHAxEEbAmPlGdubNe8akA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWyRsSkTffg7/QQg5PXdSz+TjrGbvFo/mNm
	i7NNb9gttnfOYLeY8mc5k8Wmx9dYLS7vmsNmMXtJP4vFjPP7mCxuX+a1OLd9C4vF2iN32S2W
	Xr/IZHHq+mc2i1W7/jBa7L/i5SDgsWbeGkaPluYeNo/fvyYxenz7OonF43JfL5PHou9ZHjtn
	3WX3uHNtD5vH5iX1HldONLF69G1ZxejxeZNcAE8Ul01Kak5mWWqRvl0CV8aFRfOZC76yVeye
	vJ+9gXEjaxcjJ4eEgInE9b8d7BC2mMSFe+vZuhi5OIQEljJKTO3+Cld04EUTM0RiEaPE50NT
	oZy/jBLHXl0GauHgYBNQlmhs0gdpEBbQkli4pYkFxBYRCJGYfGUiC0g9s8B5Zompd06wQzS3
	MkrsOb+OFaSZU0BToulwGkSzt8TquysZQWwWAVWJHX8mMoOU8ApYSMw6EwoS5hUQlPgx+R7Y
	fGagXet3HmeCsOUlNq95ywxxtILEjrOvGSHiIhL7XrxjhLjHSWLut4ssEDUvOCS6L4pArBKQ
	+Db5EAvIKgkBWYlNB6DGSEocXHGDZQKj5Cwkm2ch2TwLyeZZSLYtYGRZxSiaWpBcUJyUXmSs
	V5yYW1yal66XnJ+7iRGYbE7/e9a/g/HuAetDjAIcjEo8vA3T00KEWBPLiitzDzGaAl00kVlK
	NDkfmNLySuINjc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	WHm3i0GlMOnGdiPNeLXOwM/1XnkOGQs463smJN99dmhpl9zEinxP3p496uYBErHnbPftbTxq
	lDRl2mtLmVtnv1Z8nLEneSmnpV/FP2MGvsqVJuGzUz9fnGJk9b3s917t4p1fkss6DquZdky7
	03Bi5vL9RjrTHnoq3D4qnfKB61VgaGEEU3qTEktxRqKhFnNRcSIAXAgJwzEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jAd2Dv9NDDG7dFLH4O+kYu8Wj+Y+Z
	Lc42vWG32N45g91iyp/lTBabHl9jtbi8aw6bxewl/SwWM87vY7K4fZnX4tz2LSwWa4/cZbdY
	ev0ik8Wp65/ZLFbt+sNosf+Kl4OAx5p5axg9Wpp72Dx+/5rE6PHt6yQWj8t9vUwei75neeyc
	dZfd4861PWwem5fUe1w50cTq0bdlFaPH501yATxRDYw2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA/KSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJ6xgzLiyaz1zwla1i9+T97A2MG1m7GDk5JARMJA68aGKGsMUkLtxbz9bFyMUh
	JLCIUeLzoanMEM5fRoljry4DZTg42ASUJRqb9EEahAW0JBZuaWIBsUUEQiQmX5nIAlLPLHCe
	WWLqnRPsEM2tjBJ7zq9jBWnmFNCUaDqcBtHsLbH67kpGEJtFQFVix5+JzCAlvAIWErPOhIKE
	eQUEJX5Mvgc2nxlo1/qdx5kgbHmJzWveQh2tILHj7GtGiLiIxL4X7xgh7nGSmPvtIssERuFZ
	SEbNQjJqFpJRs5C0L2BkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnMyeSe1gXNlgcYhR
	gINRiYe3YXpaiBBrYllxZe4hRgkOZiUR3nNf00OEeFMSK6tSi/Lji0pzUosPMZoCPTqRWUo0
	OR+YaPNK4g2NTcyMLI3MLIxMzM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTDWLgzbdXry
	hLC2tfF6x30bV2yvuSGRfu/4zqn3PBIaONm92t/WHDjQekvltceU/1OSdhUrxuVYNDUdsz41
	XYZrQ5Jic9WTrNrL3Lc/1ly0267b1q+Yp7+G7UZZu6vPipCd3O3ZRw/94bbY/NB2ztMfzw4X
	XmSxqw4OrDx7VNJFe05pkXiJ/xUlluKMREMt5qLiRAD2NhZ7fAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> On Friday 14 November 2014 15:11:58 Marek Szyprowski wrote:
> >
> > I assume that after all comments from previous versions, no more changes
> > are needed
> > to this patchset and I would really like to have it queued to v3.19.
> >
> > Arnd, Olof: could you take this patchset thought arm-soc tree? It already
> > contains all dependencies.
> >
> > Kukjin: could you ack this patchset?
> 
> I'd rather see this merged through Russell's tree, as most of the patches
> are for core code, and only three are for the platform.
> 
> For the exynos patches:
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
I'm also fine on this series for the exynos stuff:

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

And agree with Arnd's suggestion to handle in rmk tree.
(I think seems this has no dependency with samsung tree)

Thanks,
Kukjin

