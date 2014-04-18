Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaDRBPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:15:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41022 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDRBP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:15:28 -0400
X-AuditID: cbfee690-b7f266d00000287c-e6-53507cad03c4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv3 0/7] Support new Exynos3250 SoC based on Cortex-A7 dual core
Date: Fri, 18 Apr 2014 10:15:21 +0900
Message-id: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkUHdtTUCwwZxOG4u/k46xW0xad4DJ
	4vJ+bYvrX56zWsw/co7V4vOHFnaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxd87
	/9gsTl3/zGZx8k8vo8WTwx9ZLWZMfslmsX7GaxaLYzOWMFq0/93LZrF352RGB1GPNfPWMHq0
	NPewefz+NYnR4++qF8weO2fdZfe4c20Pm8fmJfUeV040sXr0bVnF6PF5k1wAVxSXTUpqTmZZ
	apG+XQJXxtm+jewF0+QqTi+7xt7AuEKii5GDQ0LAROLvMtUuRk4gU0ziwr31bF2MXBxCAksZ
	JZ53b2SBSJhI9D55ww6RWMQo0bv7FyuE08Qk8XfzYWaQKjYBLYn9L26wgdgiAgoSm3ufgRUx
	C/xilvj5vJkdJCEs4Cexcd85sCIWAVWJthmzWUFsXgEXiV+7r0Ktk5P4sOcR2DoJgV4OiWcb
	m5ghGgQkvk0+xAJxt6zEpgPMEPWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGJXnFibnFpXrpe
	cn7uJkZgxJ3+92zCDsZ7B6wPMSYDjZvILCWanA+M2LySeENjMyMLUxNTYyNzSzPShJXEedUe
	JQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDTc9STlV/XsbGG7kKj6CfVlUxWcVy8QnHjm
	DEdlc+sO8QaNo+WvnYQe37q8OPlhhvJO7V1abdJz/4ZvnFjT/2XHdNb7S/O3+TQY39jX+2Su
	5urXe7ZNOzqNU1TH/9AUt5j5OscuruY8prJ7q+F+1ycy6usvTOTceeHyKpXwEmdPpbMBD9x4
	X/5RYinOSDTUYi4qTgQAIMCaJ84CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAd21NQHBBs86DC3+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWtgtehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8Fn/v
	/GOzOHX9M5vFyT+9jBZPDn9ktZgx+SWbxfoZr1ksjs1YwmjR/ncvm8XenZMZHUQ91sxbw+jR
	0tzD5vH71yRGj7+rXjB77Jx1l93jzrU9bB6bl9R7XDnRxOrRt2UVo8fnTXIBXFENjDYZqYkp
	qUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QD8qKZQl5pQChQIS
	i4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPO9m1kL5gmV3F62TX2BsYVEl2MnBwSAiYS
	vU/esEPYYhIX7q1n62Lk4hASWMQo0bv7FyuE08Qk8XfzYWaQKjYBLYn9L26wgdgiAgoSm3uf
	gRUxC/xilvj5vBlslLCAn8TGfefAilgEVCXaZsxmBbF5BVwkfu2+ygKxTk7iw55H7BMYuRcw
	MqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7oZ9I7GFc1WBxiFOBgVOLhvfDVP1iINbGs
	uDL3EKMEB7OSCK9yaUCwEG9KYmVValF+fFFpTmrxIcZkoO0TmaVEk/OBySavJN7Q2MTMyNLI
	3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhhLnj1JWKz1hyGnc2fbwvO1NtaH
	bFmd7nI9iv01sWXONo3igy0RR0te9Hc6Gf2fqpLK+6lnkoDz1nshme9jRB2Z8yv1H8oc7hZb
	s3G7gfG/c1zzUgNL7i9Q2LRO48rrx0pi7nOmqh9L4XvcZ7NPaJuuTDODZfq3/FLV1LOrw8x6
	Jquw2H2fdE+JpTgj0VCLuag4EQChcy71LAMAAA==
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
- Support secondary CPU of Exynos3250 (cpu up/down)
- Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/pwm/amba
- Support the clock control for Exynos3250 using common clk framework

This patchset is based on following git repo/branch.
- git repo : git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
- branch   : for-next (Linux 3.15-rc1)

Additional patch description about static memory mapping:
This patchset must need to map memory mapping about SYSRAM/PMU for CPU UP/DOWN.
So, this patchset need to merge following patchset to remove static memory
mapping for SYSRAM[1] / PMU ([2] or [3]).

[1] http://www.spinics.net/lists/arm-kernel/msg323011.html
[2] https://lkml.org/lkml/2014/4/2/48
[3] http://www.spinics.net/lists/arm-kernel/msg316013.html

And,
The pinctrl patch for Exynos3250 was posted as separated patch[4].
[4] https://lkml.org/lkml/2014/4/13/156

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

Chanwoo Choi (4):
  ARM: EXYNOS: Add Exynos3250 SoC ID
  ARM: EXYNOS: Support secondary CPU boot of Exynos3250
  ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7
  dt-bindings: add documentation for Exynos3250 clock controller

Kyungmin Park (1):
  ARM: EXYNOS: Support secondary CPU boot of Exynos4212

Tomasz Figa (2):
  clk: samsung: exynos3250: Add clocks using common clock framework
  ARM: dts: Add device tree sources for Exynos3250

 .../devicetree/bindings/clock/exynos3250-clock.txt |  41 ++
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi          | 477 +++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi                  | 427 +++++++++++
 arch/arm/mach-exynos/Kconfig                       |  22 +
 arch/arm/mach-exynos/exynos.c                      |   2 +
 arch/arm/mach-exynos/firmware.c                    |  21 +-
 arch/arm/mach-exynos/hotplug.c                     |  19 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |  10 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos3250.c               | 785 +++++++++++++++++++++
 include/dt-bindings/clock/exynos3250.h             | 256 +++++++
 11 files changed, 2053 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos3250-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos3250.c
 create mode 100644 include/dt-bindings/clock/exynos3250.h

-- 
1.8.0

