Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3AVBdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:33:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24301 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3AVBdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:33:16 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-fb-50fdec5bef3e
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'amit daniel kachhap'" <amit.daniel@samsung.com>,
        "'Zhang Rui'" <rui.zhang@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonghwa3.lee@samsung.com
References: <1353937640-9939-1-git-send-email-amit.kachhap@linaro.org>
 <CADGdYn7SpsaJ54OoxuUw3XnEpdi+qReEHw2wX=3rTQ-f2edNUg@mail.gmail.com>
 <CADGdYn6UqNhBmZxcU9k+=K5zZV8rBa6LtJJF0kNzd=RpzJ8B9g@mail.gmail.com>
In-reply-to: <CADGdYn6UqNhBmZxcU9k+=K5zZV8rBa6LtJJF0kNzd=RpzJ8B9g@mail.gmail.com>
Subject: RE: [PATCH V2 0/3] thermal: Add support for interrupt based
 notification to thermal layer
Date: Mon, 21 Jan 2013 17:32:58 -0800
Message-id: <04d101cdf840$6a547e10$3efd7a30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIz3trAQxLAxTkAJX7z4SrUCP8i9wIlx39xAui3oJyXYE3mMA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zfd3oN38DDC71i1tc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX8W/qGrWAGd8WO/btZGhhfcXQxcnJICJhITDhyiRHC
	FpO4cG89WxcjF4eQwDJGifc37zHDFB1f0sgOkVjEKHH69RwmCOcvo8SEs8vZQarYBDQkDr9/
	BmRzcIgIREic7SwEqWEWaGGUmDHnOQtEwxVGiUmf/oI1cAoES/ROagDbLSyQIvG1vwvMZhFQ
	ldg09TaYzStgKfEBqoZXQFDix+R7LCA2s4CWxOZtTawQtrzE5jVvoU5VkNhx9jUjxBFOEud6
	4iBKxCUmPXgI9oGEwDJ2id19j9ghdglIfJt8iAWkXkJAVmLTAagxkhIHV9xgmcAoMQvJ5llI
	Ns9CsnkWkhULGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoTEmfQOxlUNFocYBTgYlXh4
	H9z/GyDEmlhWXJl7iFGCg1lJhHdGFFCINyWxsiq1KD++qDQntfgQYzLQsROZpUST84EpIK8k
	3tDY2MTMxNTE3NLU3JQ0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1MMrYKqorbXs2Y9pH
	H44ZhUtU5e/vMnivJPbpzcK0g84p0a6pBk5u62W+LOnNCRGKN+BlTDgw6VgIu2vujllL5Zfd
	S8gpOPJX/UR9aPG0svp8M93CCy/X/NS4NuVXor9I0fofhgf0/TJuPVJPD1KJ88gIcSu+5z2v
	O6X92Ld71ZJpDyf+VNDlVmIpzkg01GIuKk4EAN3LTFH3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAd3oN38DDE7/FrS4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+Lf0DVvBDO6K
	Hft3szQwvuLoYuTkkBAwkTi+pJEdwhaTuHBvPVsXIxeHkMAiRonTr+cwQTh/GSUmnF0OVsUm
	oCFx+P0zIJuDQ0QgQuJsZyFIDbNAC6PEjDnPWSAarjBKTPr0F6yBUyBYondSAyOILSyQIvG1
	vwvMZhFQldg09TaYzStgKfEBqoZXQFDix+R7LCA2s4CWxOZtTawQtrzE5jVvmSFOVZDYcfY1
	I8QRThLneuIgSsQlJj14yD6BUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIER/Ez6R2MqxosDjEKcDAq8fA+uP83QIg1say4MvcQowQHs5II74wooBBvSmJl
	VWpRfnxRaU5q8SHGZKBHJzJLiSbnAxNMXkm8obGJmZGlkZmFkYm5OWnCSuK8jKeeBAgJpCeW
	pGanphakFsFsYeLglGpgjOXKP+1+1ef8V9YXbdzJiw9HGuc9+rV+ol548c/DcfrxNVeOLXO5
	zhxs+9VA/+rvhPC2GGMbJwPVw67Od13e3+TeoC0kxZOmlrLHZOlNV6PX7Nofil6/W8d2O616
	On/fC6eYbeIawq+i3A+cVy5+biU289rpOZHGKw6/62FVt3vfbvnKkl9KiaU4I9FQi7moOBEA
	95a1rCYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Daniel Kachhap wrote:

> > On Mon, Nov 26, 2012 at 5:47 AM, Amit Daniel Kachhap
> > <amit.kachhap@linaro.org> wrote:
> >> Changes since V1: Used the new thermal trend type macro
> >>
> >> The patch submitted by Jonghwa Lee
> (https://patchwork.kernel.org/patch/1683441/)
> >> adds support for interrupt based notification to thermal layer. This is
a
> good
> >> feature but the current code need more fixes to support that feature so
> using 2 new thermal
> >> trend type to implement this feature and some falling interrupt fixes.
> >>
> >> All these patches are based on thermal maintainer thermal branch.
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git thermal
> >>
> >> Amit Daniel Kachhap (2):
> >>   thermal: exynos: Miscellaneous fixes to support falling threshold
> >>     interrupt
> >>   thermal: exynos: Use the new thermal trend type for quick cooling
> >>     action.
> >>
> >> Jonghwa Lee (1):
> >>   Thermal: exynos: Add support for temperature falling interrupt.
> >>
> >>  drivers/thermal/exynos_thermal.c             |  108
+++++++++++++++--------
> ---
> >>  include/linux/platform_data/exynos_thermal.h |    3 +
> >>  2 files changed, 67 insertions(+), 44 deletions(-)

This whole series looks good to me. And if you want to add my ack as a
maintainer of EXYNOS SoCs, feel free.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

