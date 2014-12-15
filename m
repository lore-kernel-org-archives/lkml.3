Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaLOO5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:57:22 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36770 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLOO5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:57:12 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b0-548ef6c5685e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/3] devfreq: exynos: Add driver for Exynos3250
Date: Mon, 15 Dec 2014 15:56:50 +0100
Message-id: <1418655413-25410-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xq7pHv/WFGCz/qGGxccZ6VovrX56z
	Wsw/co7V4vULQ4v+x6+ZLc42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+Txdojd9ktll6/yGRx
	u3EFmwOvx5p5axg9Nq3qZPPYvKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDLaP09mLljM
	U7HzajdbA+NSzi5GTg4JAROJ2W9aWSFsMYkL99azdTFycQgJLGWU+Nrygg0kISTQxyTx/jI/
	iM0mYCyxefkSsCIRgedMEjtnvWEBcZgFZjBK3Fu4iwWkSljASWJh/2lGEJtFQFXi9qnNQCs4
	OHgF3CUWHFWG2CYncfLYZNYJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE15cd
	jIuPWR1iFOBgVOLhTdjbGyLEmlhWXJl7iFGCg1lJhHfWu74QId6UxMqq1KL8+KLSnNTiQ4xM
	HJxSDYxLuq8nv2Gb8ZtJYu2KdJGzqzY8YCqM0Z/75N/fJycV2+5+Px9ovcSKeU2WTKlX1J+i
	77fFDvBvSWO4ziH4WKb3xJvKHQdunNWqWzQ5etK9H/f5zicyBp45teXr9eOlS859fu7XffBD
	pPAV65NCl/rvRq58PytznnThqoLdnW3Xr91sFL0QWOFsosRSnJFoqMVcVJwIAAjWD3ANAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v1
================
1. Patch 1/3, bindings: fixes after review from Mark Rutland.
2. Patch 2/3, driver: update perf benchmarks.
3. Rebase on Chanwoo's devfreq-event class patches v3 [1].


Description
===========
The aim of patchset is to gather feedback about adding new devfreq driver for
Exynos 3250, along with the bindings.

The patchset uses devfreq-event class posted recently [1].

Chanwoo,
You were the author of our initial exynos3_bus.c driver so do you
want me to add your Signed-off-by?

[1] [RFC PATCHv3 0/7] devfreq: Add devfreq-event class to provide
    raw data for devfreq device
    https://lkml.org/lkml/2014/12/12/219


Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  devfreq: dt-bindings: Document bindings for Exynos3250 bus DVFS driver
  devfreq: exynos: Add driver for Exynos3250
  ARM: dts: Add devfreq to Exynos3250 and Rinato board

 .../bindings/arm/samsung/exynos3250-devfreq.txt    |  62 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  12 +
 arch/arm/boot/dts/exynos3250.dtsi                  |  26 +
 drivers/devfreq/Kconfig                            |  12 +
 drivers/devfreq/Makefile                           |   1 +
 drivers/devfreq/exynos/Makefile                    |   1 +
 drivers/devfreq/exynos/exynos3_bus.c               | 847 +++++++++++++++++++++
 7 files changed, 961 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos3250-devfreq.txt
 create mode 100644 drivers/devfreq/exynos/exynos3_bus.c

-- 
1.9.1

