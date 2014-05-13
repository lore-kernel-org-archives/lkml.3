Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbaEMNGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:06:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15888 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478AbaEMNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:06:35 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-8d-537218d939c0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv5 0/5] Support new Exynos3250 SoC based on Cortex-A7 dual core
Date: Tue, 13 May 2014 22:05:03 +0900
Message-id: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkQPemRFGwwb+9GhZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLUDx+xNYLHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3L
	vBZ/7/xjszh1/TObxck/vYwWTw5/ZLWYMfklm8X6Ga9ZLI7NWMJo0f53L5vF3p2TGR3EPNbM
	W8Po0dLcw+bx+9ckRo+/q14we+ycdZfd4861PWwem5fUe1w50cTq0bdlFaPH501yAVxRXDYp
	qTmZZalF+nYJXBmfPx5gLDikULF24g2WBsblUl2MnBwSAiYSz5ZfYYewxSQu3FvP1sXIxSEk
	sJRR4vTfVUwwRc+/HGMFsYUEFjFK3PovD1HUxCSx8tMXsG42AS2J/S9usIHYIgK6ElNm3gFr
	YBZoZZHo21IDYgsL+EkcezcJrJ5FQFVi9ou5YDavgKvEybVdLBDL5CQ+7HnEDrJAQqCXQ2JF
	YzsTRIOAxLfJh4CKOIASshKbDjBD1EtKHFxxg2UCo+ACRoZVjKKpBckFxUnpRUZ6xYm5xaV5
	6XrJ+bmbGIGRd/rfs74djDcPWB9iTAYaN5FZSjQ5Hxi5eSXxhsZmRhamJqbGRuaWZqQJK4nz
	LnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUWOafI3U1ufCrybeafV5f7ffc5ZojcEr
	ZkY/vf37/wZsUtmxeLblvd8iDIEzUyu7j86Y53FpwtPL9/iv5eidLzXmSjqb3TnVs2yOzYWr
	TGdlOlfO2RPxRTYyeOn+tNj3HSrW/6acrnJdKxp0Llf7alnmuY5ZD/1cFudn13ScW73bI6pG
	QaQsUomlOCPRUIu5qDgRANZj7GbSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd2bEkXBBguny1r8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tADF709gsehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv
	81r8vfOPzeLU9c9sFif/9DJaPDn8kdVixuSXbBbrZ7xmsTg2YwmjRfvfvWwWe3dOZnQQ81gz
	bw2jR0tzD5vH71+TGD3+rnrB7LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBFNTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9qqRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+PzxAGPBIYWKtRNvsDQwLpfqYuTk
	kBAwkXj+5RgrhC0mceHeejYQW0hgEaPErf/yXYxcQHYTk8TKT1/YQRJsAloS+1/cACsSEdCV
	mDLzDlgzs0Ari0TflhoQW1jAT+LYu0lg9SwCqhKzX8wFs3kFXCVOru1igVgmJ/FhzyP2CYzc
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/Uz6R2MqxosDjEKcDAq8fAueFYQLMSa
	WFZcmXuIUYKDWUmE1/1TYbAQb0piZVVqUX58UWlOavEhxmSg7ROZpUST84EpJ68k3tDYxMzI
	0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGDsqP1QyrMmRya62zZvA33LV
	SCbX9tm3lU3LKqXuuezYcMB3kmLYLrn8U9PTVdi1NKLna0u87jwhpeBapuDGld+9XMRZ4/bm
	E2c793/6J71c2GPSr7fR3/Y/auI880Hiatd3ucnin/NdV0v7XSrvfCv0Z6FqaY3I6f7p58uP
	378tbmW5t2m1thJLcUaioRZzUXEiAD6sbDMvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support new Exynos3250 Samsung SoC based on Cortex-A7 dual core.
Exynos3250 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
for Smartphone. It is desigend with the 28nm low-power high-K metal gate process
and provides the best performance features.

This patchset include some patches such as:
- Support booting of Exynos3250
- Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/pwm/amba
- Support the clock control for Exynos3250 using common clk framework

This patchset is based on following git repo/branch.
- git repo : git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
- branch   : for-next (2ca8b247775d7c24fa8c2524a5562bad7e88f84b)

Changes from v4:
- Rebase this patch on latest for-next branch in linux-samsung.git
- Post separated secondary CPU boot patch for Exynos4212 and merged it
 : https://lkml.org/lkml/2014/5/8/745
- Drop following patch[1] and use alternative patch[2] to turn off Cortex-A7
  [1] ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7
  [2] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg29064.html
- Modify clock driver of exynos3250
- Add 'soc' dt node and move all dt nodes under 'soc' dt node in exynos3250.dtsi
- Add missing CPU1 dt node in exynos3250.dtsi
- Fix minor issue about coding style

Changes from v3:
- Remove all dependency about following patchset to remove static memory
  mapping for SYSRAM[1] / PMU ([2] or [3]). If following patchset merged,
  I'll send a further patches to support SYSRAM/PMU for secondary CPU.
  [1] http://www.spinics.net/lists/arm-kernel/msg323011.html
  [2] https://lkml.org/lkml/2014/4/2/48
  [3] http://www.spinics.net/lists/arm-kernel/msg316013.html

Changes from v2:
- Remove static memory mapping about SYSRAM/PMU such as following patches:
  ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of Exynos3250
  ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
- Add description for secondary CPU boot of Exynos4212/Exynos3250
- Fix description in exynos_cpu_die() to remove particular SoC series
- Fix minor coding style
- Add documentation for Exynos3250 clock controller

Changes from v1:
- Add new "samsung,exynos3" compatible name
- Add comment about exynos_cpu_boot in Exynos4212
- Remove unnecessary 'goto' statement in firmware.c
- Use read_cpuid_part_number() function instead of assembler directly
- Post separated pinctrl patch from this patchset
  : https://lkml.org/lkml/2014/4/13/156
- Remove unused pmu interrupts due to Exynos3250 dual-core
- Cosolidate all the patches related to exynos3250.dtsi into one patch
- Fix gic compatible name to "cortex-a15-gic" because Cortex-A7 GIC is same
- Add sign-off of sender to all this patches
- Fix minor typo

Chanwoo Choi (3):
  ARM: EXYNOS: Add Exynos3250 SoC ID
  ARM: EXYNOS: Support secondary CPU boot of Exynos3250
  dt-bindings: add documentation for Exynos3250 clock controller

Tomasz Figa (2):
  clk: samsung: exynos3250: Add clocks using common clock framework
  ARM: dts: Add device tree sources for Exynos3250

 .../devicetree/bindings/clock/exynos3250-clock.txt |  41 ++
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi          | 475 +++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi                  | 439 ++++++++++++
 arch/arm/mach-exynos/Kconfig                       |  22 +
 arch/arm/mach-exynos/common.h                      |  10 +
 arch/arm/mach-exynos/exynos.c                      |   2 +
 arch/arm/mach-exynos/firmware.c                    |   9 +-
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos3250.c               | 782 +++++++++++++++++++++
 include/dt-bindings/clock/exynos3250.h             | 258 +++++++
 10 files changed, 2038 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos3250-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos3250.c
 create mode 100644 include/dt-bindings/clock/exynos3250.h

-- 
1.8.0

