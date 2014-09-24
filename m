Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaIXDyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 23:54:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40142 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaIXDyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 23:54:07 -0400
X-AuditID: cbfee691-f79b86d000004a5a-85-5422405d8030
From: Kukjin Kim <kgene@kernel.org>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>
References: <20140924110836.209bc8e2@canb.auug.org.au>
In-reply-to: 
Subject: RE: linux-next: build failure after merge of the samsung tree
Date: Wed, 24 Sep 2014 12:54:05 +0900
Message-id: <010701cfd7ab$2f7acc30$8e706490$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHv9Y7pls0ew4DeOAaPdZa0uXmLbJvPXEaQgAAOZVA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfd1YB6UQg9fz5C02zljPanH0d4HF
	5V1z2CwOLmxjtHg64SKbxda9V9kd2Dwab9xg8/j7/DqLx51re9g8+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK6P/+RnWgnaeinfnWxkbGBdxdjFycEgImEj0/azoYuQEMsUkLtxbz9bFyMUh
	JLCMUWLavdssEAkTiUern7NAJKYzSjy/eZMVwvnLKPHtWA8byCQ2AWWJxiZ9kAZhAS2JhVua
	wJpFBHQl+v7NZwKpZxZ4xCixb00zK0i9kICZRPfKapAaTgEeiXV/Opkhet0kHv9fB9bLIqAq
	sXzWeTYQm1fAQmLO4R52CFtQ4sfke2A1zEC7Nm9rYoWw5SU2r3nLDHG0gsSOs68ZIW6wkvi2
	eiYbRI2IxL4X7xghat6yS6z4ZQGxS0Di2+RDLJBAkZXYdABqjKTEwRU3WCYwSs5CsnkWks2z
	kGyehWTDAkaWVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxghcTxxB+P9A9aHGAU4GJV4eCeI
	K4UIsSaWFVfmHmI0BbpoIrOUaHI+MFnklcQbGpsZWZiamBobmVuaKYnz6kj/DBYSSE8sSc1O
	TS1ILYovKs1JLT7EyMTBKdXAuOqn3O1JmzIur992tFCcaaPyMRe2FRzpV4sEFy3Ncvj2U5ux
	z/6C4onrPUEWu7xbFr34pmJa2H0vb6LkExszWYEbycstNCZP3yd+zq69PONPkoEKQ7NAzq33
	cq3nFrM+ftG6alaZ5ebjPqVhl3yb/x/t31hgcU3i5mKphTzFcg9MDSxfzAvlUmIpzkg01GIu
	Kk4EAAx2p+jeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd1YB6UQg0PTpC02zljPanH0d4HF
	5V1z2CwOLmxjtHg64SKbxda9V9kd2Dwab9xg8/j7/DqLx51re9g8+rasYvT4vEkugDWqgdEm
	IzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gCJYWyxJxS
	oFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWNG//MzrAXtPBXvzrcyNjAu4uxi5OSQ
	EDCReLT6OQuELSZx4d56ti5GLg4hgemMEs9v3mSFcP4ySnw71gOU4eBgE1CWaGzSB2kQFtCS
	WLilCaxZREBXou/ffCaQemaBR4wS+9Y0s4LUCwmYSXSvrAap4RTgkVj3p5MZotdN4vH/dWC9
	LAKqEstnnWcDsXkFLCTmHO5hh7AFJX5MvgdWwwy0a/O2JlYIW15i85q3zBBHK0jsOPuaEeIG
	K4lvq2eyQdSISOx78Y5xAqPwLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECE4Uz6R3MK5qsDjEKMDBqMTDO0FcKUSINbGsuDL3EKMEB7OSCO8+VaAQb0piZVVq
	UX58UWlOavEhRlOgTycyS4km5wOTWF5JvKGxiZmRpZGZhZGJubmSOO/BVutAIYH0xJLU7NTU
	gtQimD4mDk6pBkbTnTJ/ti5w55mw8Qi76w+ejFlPXJs7mZvvli1eUPbAMeh/E2etQ90V04cR
	89mf3P0jmGR2l8fjQTvvvIKJPgnCLzYwOlyaWyQ/3f3Jrc97d3kn/WgsZujclrK9meV5o1WX
	eO+Hi++Nl3wPX3rrjVyDwlMfv8MZSndExdqfT51/NPLtL/7gL3JKLMUZiYZazEXFiQBSrv6Q
	KgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> Stephen Rothwell wrote:
> >
> > Hi Kukjin,
> >
> Hi Stephen,
> 
> > After merging the samsung tree, today's linux-next build (arm multi_v7_defconfig)
> > failed like this:
> >
> > arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/clock/maxim,max77686.h: No
> such
> > file or directory
> >  #include <dt-bindings/clock/maxim,max77686.h>
> >                                               ^
> >
> + Mike
> 
> Hmm... I think, inclusion of the header file should be included in Mike's clk
> tree...What's wrong?
> 
Just note, I've merged Mike's clk-next into my -next tree.

> > Caused by commit c04c92ed5614 ("ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow").
> >
> > In file included from arch/arm/mach-tegra/cpuidle-tegra114.c:17:0:
> > arch/arm/mach-tegra/cpuidle-tegra114.c: In function 'tegra114_idle_power_down':
> > arch/arm/include/asm/firmware.h:64:24: error: too few arguments to function 'firmware_ops->do_idle'
> >   ((firmware_ops->op) ? firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
> >                         ^
> > arch/arm/mach-tegra/cpuidle-tegra114.c:52:6: note: in expansion of macro 'call_firmware_op'
> >   if (call_firmware_op(do_idle) == -ENOSYS)
> >       ^
> >
> > Caused by commit f5217f3b9332 ("ARM: EXYNOS: add AFTR mode support to
> > firmware do_idle method").
> 
> OK, I'll revert it firstly. Thanks.
> 
Reverted just now.

> >
> > I have used the samsung tree from next-20140923 for today.
> 
> OK.
> 
> - Kukjin

