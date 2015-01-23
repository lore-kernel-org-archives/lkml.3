Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbbAWH4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:56:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53703 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbAWH4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:56:35 -0500
X-AuditID: cbfee691-f79b86d000004a5a-7c-54c1feb01090
From: Kukjin Kim <kgene@kernel.org>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCH v9 0/7] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
Date: Fri, 23 Jan 2015 16:56:32 +0900
Message-id: <0dd401d036e2$1a4431d0$4ecc9570$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQJfN+xh9VpZWCYVKIRtX/Pihw1mXpuvUvng
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zge6GfwdDDG5uNbF4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHsUl01Kak5mWWqRvl0CV0ZbT1DBbfGKlXvfszUw3hfsYuTkkBAwkVi0cxUThC0mceHe
	erYuRi4OIYFljBLvnm9mgSlq7VzABmILCUxnlDj6qg6i6C+Q/XceUIKDg01AWaKxSR+kRlhA
	S2LhliawXhGBCIk37VfAhjILPGaSePZiKhPEIBeJ5s/vwWxOAVeJ7VsuM0I0p0rsO3aECWQm
	i4CqxJ4NySBhXgELiamNvxghbEGJH5Pvgc1nBtq1fudxJghbXmLzmrfMEDcrSOw4+5oRIi4i
	se/FO0aIe4wk7s34yw5yj4TAHg6J80e2gTWzCAhIfJt8iAVkr4SArMSmA1BzJCUOrrjBMoFR
	chaS1bOQrJ6FZPUsJOsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAhJHhN3MN4/YH2I
	UYCDUYmHt2HLwRAh1sSy4srcQ4ymQBdNZJYSTc4Hpqi8knhDYzMjC1MTU2Mjc0szJXFeHemf
	wUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYy1l7H5nrXNSIFN7g1lvvbftjwaVcrodfVq4X
	/2gVGRGS3l8qLvl3ZtyqJpcjsVtO3Vj0wltT8e3SIodJZr1P2xWL3t277vMqY8Isr/aGJjc7
	GcWF11qedSUx2PPIzayrEmzccaVHO0v9w++rOYf2e0Seqdy/47Dv1SZdB8+XTzK+Jf/67r1R
	iaU4I9FQi7moOBEAq0XUFxkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jQd0N/w6GGBzermfxeM1iJouNM9az
	Wlz/8pzVYtL9CSwWr18YWvQ/fs1scbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVr3HmG3WLXrD6ODgMeaeWsYPXbOusvusXjPSyaPTas62Tw2L6n36NuyitHj
	8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfM
	HKDjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZbT1BBbfFK1bufc/W
	wHhfsIuRk0NCwESitXMBG4QtJnHh3nowW0hgOqPE0Vd1XYxcQPZfIPvvPKAEBwebgLJEY5M+
	SI2wgJbEwi1NLCC2iECExJv2K2wg9cwCj5kknr2YygQxyEWi+fN7MJtTwFVi+5bLjBDNqRL7
	jh1hApnJIqAqsWdDMkiYV8BCYmrjL0YIW1Dix+R7YPOZgXat33mcCcKWl9i85i0zxM0KEjvO
	vmaEiItI7HvxjhHiHiOJezP+sk9gFJ6FZNQsJKNmIRk1C0n7AkaWVYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxjBqemZ1A7GlQ0WhxgFOBiVeHgbthwMEWJNLCuuzD3EKMHBrCTCG/cFKMSb
	klhZlVqUH19UmpNafIjRFOjRicxSosn5wLSZVxJvaGxiZmRpZGZhZGJuriTOq2TfFiIkkJ5Y
	kpqdmlqQWgTTx8TBKdXAuHn6upBlzTu+ngj0edrIGTpT4e9G7h9P/081WDotgjeIq2ndjrB/
	P4P3NSbpe1zqTfsjtfqD7cLCVgkx3gk8OVJnGnq51a+m3bWYLhlwZOnitdsO9sZFVNtoNX8L
	Wie+d9unb5LX2IWNN65LV+TcXme8MtLQdRb3+3WO75I3vHk+Z+FhfvcTfEosxRmJhlrMRcWJ
	ACtPj39jAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
Hi,

> This patchset add new devfreq_event class to provide raw data to determine
> current utilization of device  which is used for devfreq governor.
> 
Yes, would be nice to use common framework something like the devfreq_event you created :)

> The following description explains the feature of two kind of devfreq class:
> - devfreq class (existing)
>  : devfreq consumer device use raw data from devfreq_event device for
>    determining proper current system state and change voltage/frequency
>    dynamically using various governors.
> - devfreq_event class (new)
>  : Provide measured raw data to devfreq device for governor

[...]

> Chanwoo Choi (7):
>   devfreq: event: Add new devfreq_event class to provide basic data for devfreq governor
>   devfreq: event: Add exynos-ppmu devfreq-event driver
>   devfreq: event: Add documentation for exynos-ppmu devfreq-event driver
>   ARM: dts: Add PPMU dt node for Exynos3250 SoC
>   ARM: dts: Add PPMU dt node for Exynos4 SoCs
>   ARM: dts: exynos: Add PPMU node for Exynos3250-based Rinato/Monk board
>   ARM: dts: exynos: Add PPMU node for Exynos4412-based TRATS2 board
> 
>  .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++
>  arch/arm/boot/dts/exynos3250-monk.dts              |  40 ++
>  arch/arm/boot/dts/exynos3250-rinato.dts            |  40 ++
>  arch/arm/boot/dts/exynos3250.dtsi                  |  74 +++
>  arch/arm/boot/dts/exynos4.dtsi                     | 108 +++++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   8 +
>  arch/arm/boot/dts/exynos4412-trats2.dts            |  40 ++
>  drivers/devfreq/Kconfig                            |   2 +
>  drivers/devfreq/Makefile                           |   6 +-
>  drivers/devfreq/devfreq-event.c                    | 498 +++++++++++++++++++++
>  drivers/devfreq/event/Kconfig                      |  25 ++
>  drivers/devfreq/event/Makefile                     |   2 +
>  drivers/devfreq/event/exynos-ppmu.c                | 374 ++++++++++++++++
>  drivers/devfreq/event/exynos-ppmu.h                |  93 ++++
>  include/linux/devfreq-event.h                      | 196 ++++++++
>  15 files changed, 1615 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
>  create mode 100644 drivers/devfreq/devfreq-event.c
>  create mode 100644 drivers/devfreq/event/Kconfig
>  create mode 100644 drivers/devfreq/event/Makefile
>  create mode 100644 drivers/devfreq/event/exynos-ppmu.c
>  create mode 100644 drivers/devfreq/event/exynos-ppmu.h
>  create mode 100644 include/linux/devfreq-event.h
> 
> --

Looks good to me.

Myungjoo, shall I take DT changes in this series into Samsung tree?

4/7 ARM: dts: Add PPMU dt node for Exynos3250 SoC
5/7 ARM: dts: Add PPMU dt node for Exynos4 SoCs
6/7 ARM: dts: exynos: Add PPMU node for Exynos3250-based Rinato/Monk board
7/7 ARM: dts: exynos: Add PPMU node for Exynos4412-based TRATS2 board

Thanks,
Kukjin

