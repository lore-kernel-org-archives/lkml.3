Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaAHRmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:42:36 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32895 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaAHRmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:42:32 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f1-52cd8e066749
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, tjakobi@math.uni-bielefeld.de,
        stern@rowland.harvard.edu
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
 <1387545857-9472-11-git-send-email-k.debski@samsung.com>
 <52CA845C.5080308@ti.com>
In-reply-to: <52CA845C.5080308@ti.com>
Subject: RE: [PATCH RFC alternative ver 1] phy: Exynos 421x USB 2.0 PHY support
Date: Wed, 08 Jan 2014 18:42:27 +0100
Message-id: <04db01cf0c99$00f79970$02e6cc50$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8KyYYBOerwgdTkT0eYD6ujXfI7SwBzrf2w
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xK7psfWeDDLb9YLdYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBYXnvawWZxtegPk7prDZjHj/D4mi0XLWpkt1h65y25xtv82m8XE
	pmnsFue3dDJZHH7Tzmox4fcFNov1M16zWLSt/sBq0XH2ILuDsMflvl4mj52z7rJ73Lm2h83j
	3zF2j9l3fzB69G1Zxehx/MZ2Jo/Pm+QCOKK4bFJSczLLUov07RK4Mqat2sRccIev4m3favYG
	xj3cXYycHBICJhJXLh1mgbDFJC7cW8/WxcjFISSwlFGi61AXM4TTwCRx8kE3kMPBwSagKbHq
	ngdIg4iAjsTC0+vBapgFZrJIfPw8lQmiYRajxJdDC1hAGjgF1CQmzBMDaRAW8Je4vuE1I4jN
	IqAqMWfXZ7DNvAIOEgeaGlkhbEGJH5PvgcWZBbQk1u88zgRhy0tsXvMW7AYJAXWJR391QUwR
	ASOJiy9tICpEJO42PGedwCg0C8mgWUgGzUIyaBaSlgWMLKsYRVNLkwuKk9JzDfWKE3OLS/PS
	9ZLzczcxQuL3yw7GxcesDjEKcDAq8fBy1J4NEmJNLCuuzD3EKMHBrCTCe70YKMSbklhZlVqU
	H19UmpNafIiRiYNTqoGRjeHU5UKhAp/d/NtW3uZOctE08jl7Vu4wi8q5FXGbpA8HsOxdWC12
	//uqnYv3pG38v8227/uzlklK1+evOL3p2dKY81Yl3VstFilbWp3/dDO/w4WF101jS6JT7Ndv
	i5QSGBYqXrm8dLNFSA+zN29kmvTjlXsOf7mV9l2tP5pzhWy49Zslp2fNV2Ipzkg01GIuKk4E
	AJU3X4u9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

Thank you for your review.

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Monday, January 06, 2014 11:24 AM
> 
> Hi,
> 
> On Friday 20 December 2013 06:54 PM, Kamil Debski wrote:
> > This the alternative version of the support for Exynos 421x USB 2.0
> > PHY in the Generic PHY framework. In this version the support for
> > Exynos
> > 4210 and 4212 was joined into one file.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> > Hi,
> >
> > Me and Kishon were discussing for quite a long time the way how
> Exynos
> > 4 should be handled. I have decided to post the original patches and
> > try to make an alternative version with support for Exynos 4210 and
> > 4212 joined in one file. I have prepared two versions. The first one
> > has 506 lines (vs
> > 563 when two files are used). When doing the second version I was a
> > little more aggresive in removing code. This was done at a cost of
> > adding if's deciding which SoC version the driver is dealing with in
> some internal functions.
> > This resulted in a better number of removed lines - the second
> version
> > has only 452 lines (vs 563 original and 506 version 1).
> 
> Alright.. If the alternate approach doesn't give too much of advantage,
> lets stick with the original one. I would recommend creating a
> documentation (Documentation/phy/?) for the samsung PHY since that
> actually creates a layer on top of generic PHY framework. That would
> help while adding new samsung PHY drivers.

Ok, I will prepare an updated set of patches with the documentation
added. Also I will fix other issues you pointed out in reply to other
patches from this series.

> 
> Btw thank you for preparing alternate versions for your original
> patches.

No problem :)

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

