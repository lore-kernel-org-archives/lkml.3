Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937303Ab3DJKip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:38:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50894 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936177Ab3DJKil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:38:41 -0400
X-AuditID: cbfee68d-b7f786d000005188-4e-5165412f3d8b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, balbi@ti.com,
        rob.herring@calxeda.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com,
        p.paneri@samsung.com
References: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v5 0/3] ARM: Exynos5250: Enabling dwc3-exynos driver
Date: Wed, 10 Apr 2013 19:38:39 +0900
Message-id: <310201ce35d7$90821cd0$b1865670$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hU7AN6iJdbMUXQeCi+cs2NLm38AUg343Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zQ119x9RAg93PrC0O3q+3eHlI0+LA
	7IesFmeXHWSzaLtykN3i1ZmNbBaXF15itVjYtoTF4vKuOWwWM87vY7JYtKyV2eL8lk4mi8Mr
	DjBZHJuxhNGBz2PB5yvsHrMbLrJ43Lm2h83j/IyFjB59W1Yxevx8qeNx/MZ2Jo/Pm+QCOKK4
	bFJSczLLUov07RK4Mnbvuc9esIu7YteedcwNjM84uhg5OSQETCT670xkhbDFJC7cW8/WxcjF
	ISSwjFFi5bvbrDBFHzfsZQKxhQSmM0r8maoCUfSXUWLv2U1gCTYBDYnD75+xgyREBKYwSjxt
	ucgM4jAL3GOUOLz5G0sXIwdQi4fEtldsIA2cAp4Svy70MYLYwkDh5zd7wGwWAVWJBQ9PMoGU
	8wrYSpxdagcS5hUQlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIOUSAuoSj/7qgoRFBIwkDp/5
	BFUuIrHvxTtGkGskBHZwSDz/9oMZYpWAxLfJh1ggemUlNh1ghvhXUuLgihssExglZiHZPAvJ
	5llINs9CsmIBI8sqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJDU0LuD8fYB60OMyUDrJzJL
	iSbnA1NLXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYp31ycb1tpXn68aa+i+ryy8UPtHb4if2a+7Qnr86x6tnfA89twspULDRO3uepUP/sKH7o
	0FH3a5NPdulUvF39wSPtvKX46t17G3d/jz4gvkRpvsIMD0ODlS63yq/MctRu6L18qGuWX0aW
	uE6Y8Zno+7wlHk/DZ8/QuJw3b8njiw941a50n2/8rcRSnJFoqMVcVJwIAHmEwWQjAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t9jQV19x9RAgxO7zSwO3q+3eHlI0+LA
	7IesFmeXHWSzaLtykN3i1ZmNbBaXF15itVjYtoTF4vKuOWwWM87vY7JYtKyV2eL8lk4mi8Mr
	DjBZHJuxhNGBz2PB5yvsHrMbLrJ43Lm2h83j/IyFjB59W1Yxevx8qeNx/MZ2Jo/Pm+QCOKIa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWbs3nOfvWAXd8WuPeuYGxifcXQx
	cnJICJhIfNywlwnCFpO4cG89G4gtJDCdUeLPVJUuRi4g+y+jxN6zm8CK2AQ0JA6/f8YOkhAR
	mMIo8bTlIjOIwyxwj1Hi8OZvLF2MHEAtHhLbXoFN4hTwlPh1oY8RxBYGCj+/2QNmswioSix4
	eJIJpJxXwFbi7FI7kDCvgKDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZQYplxBQl3j0VxckLCJg
	JHH4zCeochGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBieeZ9A7GVQ0WhxgFOBiVeHgXGKYECrEmlhVX5h5ilOBgVhLhtdBKDRTiTUmsrEot
	yo8vKs1JLT7EmAz050RmKdHkfGBSzCuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2
	ampBahHMFiYOTqkGxnnaW9trP8xgeGwwZ/GMot1LuhODfGSEF9i83HDNaU2ul/O+0NalTWb9
	NpNkpQ+pPvNn5b48S89C9tEJtoXGovv+2L7iXt6967dXhz9zcqNJvJi9l+GqeWbs/u9Xui6a
	uu3362Wr7J1CeOq8V3spFL9O27P5gD/TEp9Z7y7/ztmtzH3oX3vrZiWW4oxEQy3mouJEALCA
	wySAAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> This patch-set is in continuation with patch-series:
> [PATCH v4 0/4] Enable ehci, ohci and dwc3 devices on exynos5250
> out of which follwowing patches have been picked up:
> ARM: Exynos5250: Enabling ehci-s5p driver
> ARM: Exynos5250: Enabling ohci-exynos driver
> 
> Based on following patch-set for Samsung's usb PHY enablement:
> [PATCH v4 0/2] ARM: Exynos5250: Enabling samsung usb phy
> 
> and further depends on dwc3-exynos driver patch-set:
> [PATCH 0/2] dwc3: exynos: Device tree fixes
> 
> Changes from v4:
>  - Aligning with the recently merged common clock framework, thereby
>    no place for clock file changes. ;-)
>  - Adding proper binding documentation as per latest bindings changes in
>    dwc3 driver (dwc3/core.c as well as for dwc3-exynos.c change reflected
>    by above patch-set.
>  - Bifurcating the patch to separate our Documentation, arch and dts
> changes.
> 
> Vivek Gautam (3):
>   usb: Add device tree bindings for dwc3-exynos
>   ARM: exynos5250: dts: Enabling dwc3-exynos driver
>   ARM: exynos5: Enable XHCI support on exynos5
> 
>  .../devicetree/bindings/usb/exynos-usb.txt         |   34
> ++++++++++++++++++++
>  arch/arm/boot/dts/exynos5250.dtsi                  |   20 ++++++++++-
>  arch/arm/mach-exynos/Kconfig                       |    1 +
>  3 files changed, 53 insertions(+), 2 deletions(-)
> 
> --
> 1.7.6.5

Applied this series, thanks.

- Kukjin

