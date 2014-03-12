Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaCLLsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:48:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32569 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbaCLLsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:48:20 -0400
Date: Wed, 12 Mar 2014 20:47:58 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/4] devfreq: exynos4: Support dt and use common ppmu driver
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-id: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
DLP-Filter: Pass
X-AuditID: cbfee691-b7efc6d0000039d3-db-5320497eab40
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkSLfOUyHYoGUGr8X1L89ZLc42vWG3
	6P6RbXF51xw2i8+9RxgtbjeuYLN48+Msk8XjFW/ZHTg8Fu95yeTRt2UVo8fxG9uZPD5vkgtg
	ieKySUnNySxLLdK3S+DK2H7yGVPBbvaKhuUKDYyT2LoYOTkkBEwkvk27xA5hi0lcuLceLC4k
	sJRRon+nM0zNircnWLoYuYDi0xklvu0/yAjhNDJJLNjyFayDTUBLYv+LG2C2iIC5xK6lP9lA
	ipgF1jJKPPo0B8jh4BAW8JG49kkYpIZFQFXi/rTpTCA2r4CLROuqacwQ2+QkPux5xA7SKyHw
	n03iw9RrjBANAhLfJh9iAZkjISArsekAVL2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSqV5yY
	W1yal66XnJ+7iREYsqf/PZu4g/H+AetDjMlA4yYyS4km5wNDPq8k3tDYzMjC1MTU2Mjc0ow0
	YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGE2uOTP//Nq+LGPHdcnYXJ0Cr9nc
	DnnVP7c5hVhpql6LYPt3f6NQmn//Jw6G7NY3BtOZzkh6HTp3MeG4Z8DentkR99p5q97fiM5W
	Fyidn27mVH3771rbrVNUH5jPL2Zze7R9usTkNl/p9uiABjZD/lMfVp61cb7idmGp+fynW1hc
	I53imk15lViKMxINtZiLihMBdt2oD28CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQd06T4Vgg679rBbXvzxntTjb9Ibd
	ovtHtsXlXXPYLD73HmG0uN24gs3izY+zTBaPV7xld+DwWLznJZNH35ZVjB7Hb2xn8vi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b2k8+YCnazVzQsV2hgnMTW
	xcjJISFgIrHi7QkWCFtM4sK99UBxLg4hgemMEt/2H2SEcBqZJBZs+QrWwSagJbH/xQ0wW0TA
	XGLX0p9gHcwCaxklHn2aA+RwcAgL+Ehc+yQMUsMioCpxf9p0JhCbV8BFonXVNGaIbXISH/Y8
	Yp/AyL2AkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBMPJPawbiyweIQowAHoxIP7wJN
	+WAh1sSy4srcQ4wSHMxKIry7bBWChXhTEiurUovy44tKc1KLDzEmA22fyCwlmpwPjNe8knhD
	YxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamA0LpoW/aZO5U6irdyq
	L3O0FK7NNKm4qZJwv5e/+LyXZM6JXTUX2l/nP765u9kvvcOW9ako8+5S0dcn+xW5znUfrciJ
	+FlRLtbw7fCWYN0XUz4YvRDWjUt9PEd/d+qkKfOi/f6+nM7bar44yrq3MLDz6XJrpfvpX5UT
	/95dbG31UDjY+PPNBdxKLMUZiYZazEXFiQBh4qFXzQIAAA==
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support devicetree and use common ppmu driver instead of
individual code of exynos4_bus.c to remove duplicate code. Also this patchset
get the resources for busfreq from dt data by using DT helper function.
- PPMU register address
- PPMU clock
- Regulator for INT/MIF block

This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
To remove power-leakage in suspend state, before entering suspend state,
disable ppmu clocks.

Chanwoo Choi (4):
  devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
  devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
  devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
  devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro instead of legacy method

 drivers/devfreq/exynos/exynos4_bus.c | 396 ++++++++++++++++++++++++-----------
 1 file changed, 271 insertions(+), 125 deletions(-)

-- 
1.8.0

