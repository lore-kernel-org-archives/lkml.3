Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaIQMJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:09:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32608 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaIQMJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:09:31 -0400
X-AuditID: cbfee68d-f79c46d000000b84-9d-541979f9733f
From: Kukjin Kim <kgene@kernel.org>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Seungwon Jeon'" <tgih.jun@samsung.com>,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>
References: <1410857409-24767-1-git-send-email-gautam.vivek@samsung.com>
 <CAD=FV=U4rPsfGkTcSY3OYHPgCFOccaHTjG1qC6WAekOEV09Q7A@mail.gmail.com>
In-reply-to: <CAD=FV=U4rPsfGkTcSY3OYHPgCFOccaHTjG1qC6WAekOEV09Q7A@mail.gmail.com>
Subject: RE: [PATCH RESEND] ARM: DTS: correct the capability string for mmc0
Date: Wed, 17 Sep 2014 21:09:28 +0900
Message-id: <01ce01cfd270$3b3d31b0$b1b79510$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQGMSCxrGC5M56ETkSxArld9MZCVZQK1b0XpnHakOvA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zI92flZIhBs8u8VjcfX6Y0WL+kXOs
	FmeXHWSzaLtykN3i6O8Cixu/2lgtvh5ewWhxedccNosZ5/cxWXy4f5HZgctjdsNFFo+/z6+z
	eNy5tofNo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDJubt7JXLCUs+L49eXMDYwL2LsYOTkk
	BEwkFv6bzgZhi0lcuLceyObiEBJYxijxaPFXFpiiWxNXMoLYQgLTGSU2TVCDsP8ySsx4wdnF
	yMHBJqAs0dikDxIWFtCSWLilCaxVRCBCYk7vXlYQm1ngFZPE17tQ8/sZJXY9u8kMkuAUCJZY
	8/ELC0Szj8TT1U/AbBYBVYkrny4ygdi8AhYSM6+cYYawBSV+TL7HAjFUXWLSvEXMELa8xOY1
	b5khblaQ2HH2NSNEXERi34t3jBAHWUns336cCeQICYFODokN/zpZIZYJSHybfIgF5BkJAVmJ
	TQeg5khKHFxxg2UCo+QsJKtnIVk9C8nqWUjWLWBkWcUomlqQXFCclF5kqFecmFtcmpeul5yf
	u4kREvG9OxhvH7A+xCjAwajEw7vhskSIEGtiWXFl7iFGU6CLJjJLiSbnA9NKXkm8obGZkYWp
	iamxkbmlmZI4r6LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjIEljxiYtrP0TyhcGnGz
	ato6QcdDq/iuXJ0UeODyg51v7syJKTpp4r+6ZOmtUqMoY+42Ff+vvI33zVRj55yQfv3HqMg/
	yJklfN2uNsVNTr/b3T4uSSu0+TLzvknGrdO/vZauYpFt939i+0Lzz11uxb1vsi5sd1O+aCo3
	dbfVixp5xzT+nH1VukosxRmJhlrMRcWJAC4UgQvzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd2flZIhBt1dHBZ3nx9mtJh/5Byr
	xdllB9ks2q4cZLc4+rvA4savNlaLr4dXMFpc3jWHzWLG+X1MFh/uX2R24PKY3XCRxePv8+ss
	Hneu7WHz6NuyitHj8ya5ANaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ
	NzfvZC5Yyllx/Ppy5gbGBexdjJwcEgImErcmrmSEsMUkLtxbzwZiCwlMZ5TYNEENwv7LKDHj
	BWcXIwcHm4CyRGOTPkhYWEBLYuGWJhYQW0QgQmJO715WEJtZ4BWTxNe7QGO4gFr7GSV2PbvJ
	DJLgFAiWWPPxCwtEs4/E09VPwGwWAVWJK58uMoHYvAIWEjOvnGGGsAUlfky+xwIxVF1i0rxF
	zBC2vMTmNW+ZIW5WkNhx9jUjRFxEYt+Ld4wQB1lJ7N9+nGkCo/AsJKNmIRk1C8moWUjaFzCy
	rGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITifPpHcwrmqwOMQowMGoxMO74bJEiBBrYllx
	Ze4hRgkOZiUR3r5gyRAh3pTEyqrUovz4otKc1OJDjKZAn05klhJNzgemurySeENjEzMjSyMz
	CyMTc3Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYwzGnM66i5OkBTZ81EwbtX9z3onT9xZ
	oRieW37/2xbR7yfsOs9eT5mp+eCS1ZTmxXc8oibaOH16/fV73kWjRPYp4Yb6YnekwowYb0rG
	aqmfl3H/8k+CP+fDQdOaUlGee6/YzYoz97tdmCOT+ocxqUPFWC/6/7SGBdGvZj2xcExiPMOp
	znDKX12JpTgj0VCLuag4EQCmaq9cPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> Vivek,
> 
Hi,

> On Tue, Sep 16, 2014 at 1:50 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> > From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> >
> > MMC capability for HS200 is parsed in mmc/core/host.c as
> > dts string "mmc-hs200-1_8v".
> >
> > This patch corrects the dts string for Exynos5420 based peach-pit
> > and Exynos5800 based peach-pi boards.
> >
> > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

In this case, Vivek's sign is required here.

> > ---
> >
> > Hi Kukjin,
> >
> > As commented by Doug earlier for this patch, the two patches required
> >   -- mmc: dw_mmc: Make sure we don't get stuck when we get an error
> >   -- mmc: dw_mmc: change to use recommended reset procedure
> > are now merged in upstream.
> > So you can go ahead and pick this change.
> >
> >  arch/arm/boot/dts/exynos5420-peach-pit.dts |    2 +-
> >  arch/arm/boot/dts/exynos5800-peach-pi.dts  |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Thanks, I will take this patch once Vivek replies his sign on this patch.

- Kukjin

