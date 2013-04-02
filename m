Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000Ab3DBK0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:26:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52232 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761981Ab3DBK0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:26:46 -0400
X-AuditID: cbfee68d-b7f786d000005188-97-515ab264819b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>,
        linux-pm@vger.kernel.org
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com
References: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
Subject: RE: [PATCH 0/9] thermal: exynos: Add thermal driver for exynos5440
Date: Tue, 02 Apr 2013 19:26:44 +0900
Message-id: <237c01ce2f8c$92eb8ac0$b8c2a040$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4qFdxbQ1CTCZmLQmW8GZAohc85OwFdfy6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY92UTVGBBivOWFk0XA2x+PVuJrvF
	5V1z2Cw+9x5htJhxfh+TxZOHfWwWx2YsYXRg99g56y67x+I9L5k87lzbw+bRt2UVo8fnTXIB
	rFFcNimpOZllqUX6dglcGaeWHWAteCBW8bdDuoHxsmAXIyeHhICJxKe7exkhbDGJC/fWs3Ux
	cnEICSxjlDi+ejcbTFHv9qtMEIlFjBIzT01mhHD+Mkr8/fgZrJ1NQEPi8Ptn7CC2iICvRP+2
	G+wgRcwCGxglrsw5BpYQEnCT2PTlPBOIzSngLrHh63oWEFtYwFvi+eoXQDYHB4uAqsSiad4g
	YV4BW4lVW66zQdiCEj8m3wMrZxbQkli/8zgThC0vsXnNW2aQVgkBdYlHf3UhTjCSuH3wEhtE
	iYjEvhfvwG6WEPjILrFr8y9WkASLgIDEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nm
	WUg2z0KyYgEjyypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkNjt3cF4+4D1IcZkoPUTmaVE
	k/OBsZ9XEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BsYlf+9XV9TfkW6faP1t+a7zdnvNptxv2bPY1PylwpW8n9scfF790Kya3M7V9GnvtHU61tfM
	d5ZccdrAfkRULMn1UtaBM+HtKr8y1k764SKtt+juoTviUuu955s+2XSBN/GROeeaHTwmqdxL
	Lv/a3R93mYV1+ZfVawRj182aGr6Se1PHJZMHW9+sVGIpzkg01GIuKk4EANKxWsTzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd2UTVGBBjtXmVk0XA2x+PVuJrvF
	5V1z2Cw+9x5htJhxfh+TxZOHfWwWx2YsYXRg99g56y67x+I9L5k87lzbw+bRt2UVo8fnTXIB
	rFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNOLTvAWvBArOJvh3QD42XB
	LkZODgkBE4ne7VeZIGwxiQv31rN1MXJxCAksYpSYeWoyI4Tzl1Hi78fPjCBVbAIaEoffP2MH
	sUUEfCX6t91gByliFtjAKHFlzjGwhJCAm8SmL+fBxnIKuEts+LqeBcQWFvCWeL76BZDNwcEi
	oCqxaJo3SJhXwFZi1ZbrbBC2oMSPyffAypkFtCTW7zzOBGHLS2xe85YZpFVCQF3i0V9diBOM
	JG4fvMQGUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjODE8k9rBuLLB4hCjAAejEg+vw5zIQCHWxLLiytxDjBIczEoivFt1owKFeFMSK6tS
	i/Lji0pzUosPMSYD/TmRWUo0OR+YtPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKa
	nZpakFoEs4WJg1OqgTGnYXUDO9Pi7VMjpVrmlKtcmFq3Y8H04y9+RKUtO89xXPWGpMHCxs0f
	mY89nnC1aP1N63MiWVO63jz6t/9Emi+z+OqO7cvYeKZrhQu4lh/N3a5gdKlpskljqPhbu02X
	Ni2x31R6+YXbpiXRO/6KTuvflPnMstz+3/bMfMHKn0s9eov+zXp+X3CPEktxRqKhFnNRcSIA
	VFotHlADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Daniel Kachhap wrote:
> 
> This patchset adds TMU(Thermal management Unit) driver support for
> exynos5440 platform. There are 3 instances of the TMU controllers so
> necessary cleanup is done to handle multiple thermal zone.
> 
> Patch 1 [thermal: exynos: Adapt to temperature emulation core thermal]
> is a re-post of the earlier posted patch,
> https://patchwork.kernel.org/patch/2123131/.
> 

Looks OK to me on whole series, there is my ack only on 1st patch though.

So if you want to add my ack, feel free:

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

> All these patches are based on thermal maintainers git tree,
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next.
> 
> Amit Daniel Kachhap (9):
>   thermal: exynos: Adapt to temperature emulation core thermal
>     framework
>   thermal: exynos: Add support for instance based register/unregister
>   thermal: exynos: Moving into samsung directory for easy maintenance.
>   thermal: exynos: Bifurcate exynos thermal common and tmu controller
>     code
>   thermal: exynos: Make the zone handling dependent on trip count
>   thermal: exynos: small cleanups to prepare for adding exynos5440
>     driver
>   thermal: exynos: Add support for exynos5440 TMU sensor.
>   thermal: exynos: Parse the platform data from the device tree.
>   ARM: dts: Add device tree node for exynos5440 TMU controller
> 
>  .../bindings/thermal/exynos5440-thermal.txt        |   93 ++
>  Documentation/thermal/exynos_thermal_emulation     |    8 +-
>  arch/arm/boot/dts/exynos5440.dtsi                  |   43 +
>  drivers/thermal/Kconfig                            |   22 +-
>  drivers/thermal/Makefile                           |    2 +-
>  drivers/thermal/exynos_thermal.c                   | 1112
--------------------
>  drivers/thermal/samsung/Kconfig                    |   32 +
>  drivers/thermal/samsung/Makefile                   |    6 +
>  drivers/thermal/samsung/exynos4210_thermal.c       |  658 ++++++++++++
>  drivers/thermal/samsung/exynos5440_thermal.c       |  712 +++++++++++++
>  drivers/thermal/samsung/exynos_common.c            |  515 +++++++++
>  drivers/thermal/samsung/exynos_common.h            |   74 ++
>  include/linux/platform_data/exynos_thermal.h       |   37 +-
>  13 files changed, 2163 insertions(+), 1151 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos5440-
> thermal.txt
>  delete mode 100644 drivers/thermal/exynos_thermal.c
>  create mode 100644 drivers/thermal/samsung/Kconfig
>  create mode 100644 drivers/thermal/samsung/Makefile
>  create mode 100644 drivers/thermal/samsung/exynos4210_thermal.c
>  create mode 100644 drivers/thermal/samsung/exynos5440_thermal.c
>  create mode 100644 drivers/thermal/samsung/exynos_common.c
>  create mode 100644 drivers/thermal/samsung/exynos_common.h

