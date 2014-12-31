Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaLaFUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:20:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23020 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaLaFT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:19:57 -0500
X-AuditID: cbfee68f-f791c6d000004834-1c-54a3877abc6f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 0/8] devfreq: Add generic exynos memory-bus frequency
 driver
Date: Wed, 31 Dec 2014 14:19:44 +0900
Message-id: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkULeqfXGIQeMRaYvHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtusWrXH0YHfo8189YweuycdZfdY/Gel0wem5fUe/RtWcXo8XmTXABbFJdNSmpO
	Zllqkb5dAlfGlwsTWQtOi1VM+KXdwHhYsIuRk0NCwETiwsu1bBC2mMSFe+uBbC4OIYGljBKv
	Xq1lhCna+PAjE0RiEaPEt1l7oKqamCSm3JrKAlLFJqAlsf/FDbBRIgIyElc3bmcBKWIW+M8k
	8fjVclaQhLBAiMTP73+ZQWwWAVWJ/r9f2UFsXgEXicnP7kGtU5BYtnwmK0izhMAhdonJM96x
	QzQISHybfAhoKgdQQlZi0wFmiHpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchYrzgxt7g0L10v
	OT93EyMwHk7/e9a/g/HuAetDjAIcjEo8vDftFocIsSaWFVfmHmI0BdowkVlKNDkfGHV5JfGG
	xmZGFqYmpsZG5pZmSuK8C6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgXFJXfdqfYW5V
	0UsxNvvyWTK2F2XDRK4bX79n+8l630vhDTOsvxU8vDBhzRqzTfJ6cxc+3Xdqa5TyPKH3k7/s
	cV4XGG0bFjpn+c5poR923GWt4V4vn6Yy1+6P8B3VMKa5C1c7TBd4/FQhJnmnT9hzoWqHH3Gh
	X+ZzVB765xTw2P5tRuZ++e+bUpRYijMSDbWYi4oTAe1iXJeCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd2q9sUhBn1tQhaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2qAZGm4zU
	xJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygk5UUyhJzSoFC
	AYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGV8uTGQtOC1WMeGXdgPjYcEuRk4OCQET
	iY0PPzJB2GISF+6tZ+ti5OIQEljEKPFt1h4op4lJYsqtqSwgVWwCWhL7X9xgA7FFBGQkrm7c
	zgJSxCzwn0ni8avlrCAJYYEQiZ/f/zKD2CwCqhL9f7+yg9i8Ai4Sk5/dY4RYpyCxbPlM1gmM
	3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfbM6kdjCsbLA4xCnAwKvHw3rBbHCLE
	mlhWXJl7iFGCg1lJhPeyJlCINyWxsiq1KD++qDQntfgQoynQ9onMUqLJ+cBEkFcSb2hsYmZk
	aWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnVwLgyPyJG7WmjuPTZU5rn74RPTnxp
	6fVTWqv9h8mW3MJHGnqPv6/U/3WQSzBYkvvx+wWTZHacsbh11066nVHs3SnmkNtbfIXOcMav
	Cduye+q3X7fynvB6P39xYq4ig+zmBsUVvKrO2iaRjfvWdzjcm2ilkta2dGJC68Q09t7Og1az
	XO1LecSWTFViKc5INNRiLipOBAAFPXIZzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds the generic exynos bus frequency driver for memory bus
with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
support the memory bus frequency driver for Exynos SoCs.

Each memory bus block has a clock for memory bus speed and frequency
table which is changed according to the utilization of memory bus on runtime.
And then each memory bus group has the one more memory bus blocks and
OPP table (including frequency and voltage), regulator, devfreq-event
devices.

There are a little difference about the number of memory bus because each Exynos
SoC have the different sub-IP and different memory bus speed. In spite of this
difference among Exynos SoCs, we can support almost Exynos SoC by adding
unique data of memory bus to devicetree file.

This patch-set has the dependency on following patch-set[1]:
[1] [PATCHv6 0/9] devfreq: Add devfreq-event class to provide raw data for devfreq device
- https://lkml.org/lkml/2014/12/28/139

Changes from v1:
- This patchset is rebased on v3.19-rc2.
- Fix bug after wake-up from suspend state. If devfreq device fail to get event,
  exynos-busfreq retry to set the event for starting.
- Add memory bus group of Exynos4x12/Exynos4210
- Add divider clock id for Exynos4 memory bus frequency
- Support memory bus frequency driver on Exynos4412-based TRATS2 board

Chanwoo Choi (8):
  devfreq: exynos: Add generic exynos memory bus frequency driver
  devfreq: exynos: Add documentation for generic exynos memory bus frequency driver
  ARM: dts: Add memory bus node for Exynos3250
  clk: samsung: exynos4: Add divider clock id for memory bus frequency
  ARM: dts: Add memory bus node for Exynos4x12
  ARM: dts: Add memory bus node for Exynos4210
  ARM: dts: Add memory bus node for Exynos3250-based Rinato board
  ARM: dts: Add memory bus node for Exynos4412-based TRATS2 board

 .../devicetree/bindings/devfreq/exynos-busfreq.txt | 184 +++++++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  12 +
 arch/arm/boot/dts/exynos3250.dtsi                  | 125 +++++
 arch/arm/boot/dts/exynos4210.dtsi                  |  93 ++++
 arch/arm/boot/dts/exynos4412-trats2.dts            |  12 +
 arch/arm/boot/dts/exynos4x12.dtsi                  | 121 +++++
 drivers/clk/samsung/clk-exynos4.c                  |  10 +-
 drivers/devfreq/Kconfig                            |  15 +
 drivers/devfreq/Makefile                           |   1 +
 drivers/devfreq/exynos-busfreq.c                   | 588 +++++++++++++++++++++
 include/dt-bindings/clock/exynos4.h                |   7 +-
 11 files changed, 1162 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
 create mode 100644 drivers/devfreq/exynos-busfreq.c

-- 
1.8.5.5

