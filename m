Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaJ1EKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:10:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21615 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaJ1EKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:10:01 -0400
X-AuditID: cbfee68f-f791c6d000004834-3d-544f1718000b
From: Kukjin Kim <kgene@kernel.org>
To: "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: tomasz.figa@gmail.com, sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1414372318-594-1-git-send-email-cw00.choi@samsung.com>
 <544E20E3.5030609@samsung.com>
In-reply-to: <544E20E3.5030609@samsung.com>
Subject: RE: [PATCHv3 0/2] clk: samsung: Add clock controller driver for
 Exynos4415 SoC
Date: Tue, 28 Oct 2014 13:09:59 +0900
Message-id: <02dd01cff265$0a846060$1f8d2120$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI0CZL/2Z4VhfOaF/Z40tO6aLeghwGnET4Qm299vTA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zQ10Jcf8Qg6V72C2uf3nOavFnQiub
	xaT7E1gszja9Ybe4vGsOm8WM8/uYLA6/aWe1mDH5JZvFql1/GB04PXbOusvu0bdlFaPH501y
	AcxRXDYpqTmZZalF+nYJXBmzN9xkL2hnreh6uIixgbGXpYuRk0NCwETiz8IbjBC2mMSFe+vZ
	uhi5OIQEljFKXD55hBmm6OmeacwQiemMEluOT2GHcP4ySny58xoow8HBJqAs0dikD9IgLKAl
	sXBLE9gGEYFoiUvHFzKB1DMLHGCUaLiwEmyqkECKxPcFj5lAbE4BbYnFW/azQDRHSlzY8AKs
	hkVAVeLIz81g5/EKWEh8mtvCCmELSvyYfA+snhlo2fqdx5kgbHmJzWveQl2tILHj7GtGiCOs
	JCZ3HWSFqBGR2PfiHSPIQRICX9klds9ZyASxTEDi2+RDLCDPSAjISmw6ADVHUuLgihssExgl
	ZyFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJDI7t/BePeA9SFG
	AQ5GJR5eg4d+IUKsiWXFlbmHGE2BLprILCWanA9MH3kl8YbGZkYWpiamxkbmlmZK4rwLpX4G
	CwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDcN22F0Z99H7e8ebvpVqhR96WAM0UFd/ru3855
	GOHl3XtC2EuzxjyA12RC6tQi57/WaWl3RRcUi/lmzf9xZ37uQWaVE66ezf6MzFJfc6/M+5Kz
	w217rHDO1ROff/zgNV696+hrozyl3T5t7d/bH99Qc+7sy3vB97i5V2XWT3XNIz+Td1ZGmKoo
	sRRnJBpqMRcVJwIATD4ZZ+cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV0Jcf8Qg8kLmC2uf3nOavFnQiub
	xaT7E1gszja9Ybe4vGsOm8WM8/uYLA6/aWe1mDH5JZvFql1/GB04PXbOusvu0bdlFaPH501y
	AcxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzZm+4yV7QzlrR9XARYwNj
	L0sXIyeHhICJxNM905ghbDGJC/fWs3UxcnEICUxnlNhyfAo7hPOXUeLLnddAVRwcbALKEo1N
	+iANwgJaEgu3NIENEhGIlrh0fCETSD2zwAFGiYYLK8GmCgmkSHxf8JgJxOYU0JZYvGU/C0Rz
	pMSFDS/AalgEVCWO/NzMCGLzClhIfJrbwgphC0r8mHwPrJ4ZaNn6nceZIGx5ic1r3kJdrSCx
	4+xrRogjrCQmdx1khagRkdj34h3jBEbhWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJEZw2nkntYFzZYHGIUYCDUYmH1+ChX4gQa2JZcWXuIUYJDmYlEV6vHUAh
	3pTEyqrUovz4otKc1OJDjKZAn05klhJNzgemtLySeENjEzMjSyMzCyMTc3Mlcd4DrdaBQgLp
	iSWp2ampBalFMH1MHJxSDYxFh2v8lvWnbpZVXyPzm6U5+ZVu2ocTl/7qZE6Quq59ST3Ufl57
	skhlAINEzqrgcxrHzyqt3riOc1fqFIXDeyrdF3ZEr5eJcYhM2vfBuX+J/MZZDzvjDP8ZLmma
	dERF9cNLl4jEyTGa0ydlNNclvwtb+CwwYF7w+4RrV7Y9+z83YK5Q8zlmuWwlluKMREMt5qLi
	RABENF1bMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sylwester Nawrocki wrote:
> 
> On 27/10/14 02:11, Chanwoo Choi wrote:
> > Chanwoo Choi (2):
> >   clk: samsung: exynos4415: Add clocks using common clock framework
> >   clk: samsung: Document binding for Exynos4415 clock controller
> 
> Added both to my tree, thanks. In future please put DT binding
> documentation first in the series, before the actual driver patch.
> 
Hi Sylwester,

Can you please provide a topic branch for clk-exynos4415? Because exynos4415 dt
file needs inclusion of following header files.

+#include <dt-bindings/clock/exynos4415.h>
+#include <dt-bindings/clock/exynos-audss-clk.h>

Thanks,
Kukjin

