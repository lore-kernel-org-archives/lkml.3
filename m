Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3IXNmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:42:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56626 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3IXNmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:42:06 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-8f-524196ac719a
From: Kamil Debski <k.debski@samsung.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1378898858-30639-1-git-send-email-k.debski@samsung.com>
 <CAFp+6iGGSqVtCK+NBGB1ZUy_8yUgfUzpS7_xG56Dfx25tkLOuw@mail.gmail.com>
 <CAFp+6iGetST=SMkP5ETup6HY6_F=m6CgMGuw9a_iLwOR-Uyd=w@mail.gmail.com>
In-reply-to: <CAFp+6iGetST=SMkP5ETup6HY6_F=m6CgMGuw9a_iLwOR-Uyd=w@mail.gmail.com>
Subject: RE: [RFC] [PATCH] phy: Add new Exynos USB PHY driver
Date: Tue, 24 Sep 2013 15:42:03 +0200
Message-id: <001701ceb92b$dad5f3b0$9081db10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac619rL/9Qh2nThQRCyP5A3j0TrULgDMcayA
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xa7prpjkGGRw8pW/x9vsWdosLT3vY
	LM42vWG3uLxrDpvF2iN32S0Ov2lntVg/4zWLA7vHzll32T36tqxi9Dh+YzuTx+dNcgEsUVw2
	Kak5mWWpRfp2CVwZk9dtZy3YKlix6+VL5gbGe7xdjJwcEgImEqc37mSHsMUkLtxbz9bFyMUh
	JLCUUeL/3X0sEE4Dk8TleR2MXYwcHGwCmhKr7nmANIgI6ElMa57HCFLDLPCTUeLj1V5WiIZL
	jBLLb+5jBaniFAiWWLvvEhuILSxgK7F99WsmEJtFQFXi269XYKt5BRwk1rxbwQZhC0r8mHyP
	BcRmFtCSWL/zOBOELS+xec1bZpAjJATUJR791YU4wkhi/sxJbBAl4hKTHjxkn8AoNAvJpFlI
	Js1CMmkWkpYFjCyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUKi5OsOxqXHrA4xCnAwKvHw
	XkhwCBJiTSwrrsw9xCjBwawkwqtZ6xgkxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVGhfhHPDdll
	N1cm9JXbTZpe7LplSflB3XyPgovTuvfJWVYIGEkzf8v6M6t935LIBcLJk9yrw45mXDj423b7
	Z93Fpr+m3bur9UUx6Nrb16r+fJNktuX1ejC72ude0xTKfzI3aFLr+4e8S1ylvNpu5nxI+/Zx
	vv3Pmol9S6PZdjL+ZdF96H29P1OJpTgj0VCLuag4EQAaTVg5cAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com]
> Sent: Friday, September 20, 2013 1:44 PM
> 
> On Fri, Sep 20, 2013 at 5:11 PM, Vivek Gautam
> <gautamvivek1987@gmail.com> wrote:
> > On Wed, Sep 11, 2013 at 4:57 PM, Kamil Debski <k.debski@samsung.com>
> wrote:
> >> Add a new driver for the Exynos USB PHY. The new driver uses the
> >> generic PHY framework.
> >>
> >> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> >> Cc: Tomasz Figa <t.figa@samsung.com>
> >> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> >> ---
> >>
> >> Hi,
> >>
> >> This patch adds a new drive for USB PHYs for Samsung SoCs. The
> driver
> >> is using the Generic PHY Framework created by Kishon Vijay Abrahan I.
> >> It can be found here https://lkml.org/lkml/2013/8/21/29.
> >> This patch adds support to Exynos4 family of SoCs. Support for
> >> Exynos3 and
> >> Exynos5 is planned to be added in the near future.
> >>
> >> I welcome your comments.
> >
> > How do you plan to put support for exynos5 series. I can see you have
> > made separate files for exynos4210 and 4212.
> > Now for exynos5250 and above, we should be able to re-use some of the
> > functions like "4212_rate_to_clk()" and "4212_iso()".

I see two options. One - moving the functions that could be reused to
separate file.
Two - exporting these functions in let's say 4212 and using them in 5250.
What do you think?

I will also support for S5PC110 in the Exynos 4210 file, as they are very
similar.

> >
> > Let me know if i can help with something for exynos5 stuff.

Now, I am trying to run the USB device on Exynos5. The board I am using is
the Arndale board. Unfortunately I am having trouble as the USB lines from
SoC
are connected both to the device port and the USB/Ethernet chip (AX88796).
Did you use the Arndale board when working with Exynos 5?

> >
> 
> Also please add linux-usb and linux-samsung mailing list too.

I will.

[snip]

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland

