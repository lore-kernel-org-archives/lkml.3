Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967410Ab3HICYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:24:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26229 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967356Ab3HICYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 22:24:38 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a4-520452e4031b
Date: Fri, 09 Aug 2013 11:24:36 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Message-id: <20130809112436.8e44545cd503ca5a2b55a8cd@samsung.com>
In-reply-to: <20130808214343.GA19383@mudshark.cambridge.arm.com>
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
 <003801ce8eb7$d7647f10$862d7d30$@samsung.com>
 <CAL_Jsq+_5GekzXpjWrtKZi2jWuxHSJxkPmVC4zmakfjAYai=eA@mail.gmail.com>
 <5354557.DijgoUKjW2@flatron>
 <20130808214343.GA19383@mudshark.cambridge.arm.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t8zY90nQSxBBl2H9Szu3D3HavHqyA8m
	iwX7rS06Z29gt9h8cB2LRe+Cq2wWjfcmsFl8PHWc3WLT42usFpd3zWGzmHF+H5PFhRUb2S2m
	LDrMavH92zc2i5N/ehktWq73Mlms2vWH0eLlxxMsDkIeTw7OY/JYM28No8fshossHjtn3WX3
	uHNtD5vH+U1rmD02L6n3mHxjOaNH35ZVjB6fN8l5XDl6himAO4rLJiU1J7MstUjfLoEr4/Xf
	FSwFR3gqJvRuZm1gPMXZxcjJISFgItH06h8LhC0mceHeerYuRi4OIYFljBJnts5hhyl69uI3
	I0RiEaPEtoltLBDOJCaJ+Ru2gLWzCKhKnFq5jBHEZhPQklg99ziYLQIUvzztCFg3s0A7m8TN
	hX+YQBLCAmESKx7+YgOxeQUcJeZ+ewRmcwo4SFy6f5wZYkMrk8T79auYIO6wkLjQ1MEO0SAo
	8WPyPbDNzEDbNm9rYoWw5SU2r3kL1iwhcIJD4trJyVDnCUh8m3wIyOYASshKbDrADDFTUuLg
	ihssExjFZiEZOwvJ2FlIxi5gZF7FKJpakFxQnJReZKpXnJhbXJqXrpecn7uJEZIiJu5gvH/A
	+hBjMtDKicxSosn5wBSTVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbGSXlTCx5Ez61KnvAl5bRo66a84pAXMiWh1oklzRNrKrjFWQK+zZ+/cVfP
	s/mXfm1OiDFYk+wSttRSL22aRMnJKNZ1Pf4XdjasP5jbfmSVzzmdymvBbLZc17t+/WQ8ovLU
	JCwh9ku12f5i+c38btZ/9zAZ8YhZyuycmeJ7/JLYpFiriBaz0I1KLMUZiYZazEXFiQAdA4Cq
	JwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsVy+t9jAd0nQSxBBtO2aVjcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eL7t29sFif/9DJatFzvZbJYtesPo8XLjydYHIQ8nhycx+SxZt4aRo/ZDRdZPHbOusvu
	cefaHjaP85vWMHtsXlLvMfnGckaPvi2rGD0+b5LzuHL0DFMAd1QDo01GamJKapFCal5yfkpm
	XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0GtKCmWJOaVAoYDE4mIlfTtME0JD
	3HQtYBojdH1DguB6jAzQQMI6xozXf1ewFBzhqZjQu5m1gfEUZxcjJ4eEgInEsxe/GSFsMYkL
	99azdTFycQgJLGKU2DaxjQXCmcQkMX/DFhaQKhYBVYlTK5eBdbAJaEmsnnsczBYBil+edoQR
	pIFZoJ1N4ubCP0wgCWGBMIkVD3+xgdi8Ao4Sc789ArM5BRwkLt0/zgyxoZVJ4v36VUwQd1hI
	XGjqYIdoEJT4Mfke2GZmoG2btzWxQtjyEpvXvGWewCgwC0nZLCRls5CULWBkXsUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRnICeSe9gXNVgcYhRgINRiYdXcTtzkBBrYllxZe4hRgkOZiUR
	3hdZQCHelMTKqtSi/Pii0pzU4kOMycDwmMgsJZqcD0yOeSXxhsYmZkaWRmYWRibm5qQJK4nz
	Hmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqOk7v/Rdx9K7drwSmTyvj8w+d8/pnGqJXLhe6bsP
	uxssFA+ar37M33X4TTfrqftWOj+ive0718auuSaweprHlplKVqY3E05INRj2sTPOaa0P/LM7
	wYNJYMGePJVnsyb/msvoZdL+9pQwq+FdDYuW91lPA6dp/fsROCHGJsS08d5l0RUFayo2K7EU
	ZyQaajEXFScCAA95G+6EAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013 22:43:43 +0100, Will Deacon wrote:
> On Thu, Aug 08, 2013 at 10:38:10PM +0100, Tomasz Figa wrote:
> > On Thursday 08 of August 2013 08:09:49 Rob Herring wrote:
> > > On Thu, Aug 1, 2013 at 8:05 AM, Cho KyongHo <pullip.cho@samsung.com> 
> > wrote:
> > > > Should this align with ARM System MMU bindings?
> > > > System MMU in Exynos SoC is different from ARM System MMU.
> > > > It does not follows the specifications of ARM System MMU.
> > > 
> > > I'm not saying the h/w is the same or even the same spec, but how you
> > > describe a master to iommu connection needs to be done in the same
> > > way. This should be done in the same way for ALL iommu's. And if what
> > > is defined does not work for you, then we need to understand that and
> > > fix the binding now.
> > 
> > +1
> > 
> > All IOMMUs should use a generic IOMMU Device Tree bindings (and in 
> > general, the same should be true for all Device Tree bindings).
> > 
> > This means that if we already have some bindings for IOMMU, then they 
> > should be reused if possible or extended if there is anything missing.
> > 
> > Of course there might be things that such generic bindings can't specify. 
> > In this case device-specific properties can be introduced, but this is 
> > last resort.
> 
> I'm also happy to discuss and/or review bindings in light of what we did for
> the ARM SMMU.
> 
> Will

Rob, I now understood what you are talking about.
Do you mean the binding description is lack of details about connection
betwen  System MMU and its master?

thanks.

KyongHo.
