Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaDYBRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:17:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39132 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaDYBQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:16:19 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-cb-5359b75f3a22
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
Subject: [PATCHv4 0/7] Support new Exynos3250 SoC based on Cortex-A7 dual core
Date: Fri, 25 Apr 2014 10:16:05 +0900
Message-id: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkWDd+e2SwwfYvvBZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLUDx+xNYLHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3L
	QO13/rFZnLr+mc3i5J9eRosnhz+yWsyY/JLNYv2M1ywWx2YsYbRo/7uXzWLvzsmMDmIea+at
	YfRoae5h8/j9axKjx99VL5g9ds66y+5x59oeNo/NS+o9rpxoYvXo27KK0ePzJrkArigum5TU
	nMyy1CJ9uwSujHtv7ArmyFf8n+XZwDhRsouRk0NCwERi2oeJjBC2mMSFe+vZuhi5OIQEljJK
	TP7+G8jhACtaOTEZIj6dUeJy2ztmCKeJSeLvrT9sIN1sAloS+1/cALNFBHQlpsy8wwpiMwu0
	skj0bakBsYUF/CRePDgBVsMioCox+fRbsM28Aq4S/x4uYoa4Qk7iw55H7BB2L4fE/jfaEPUC
	Et8mH2KBOEhWYtMBqHJJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMw
	5k7/e9a7g/H2AetDjMlA4yYyS4km5wNjNq8k3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGDMDtrg/qFTTd/mdIf2ZZaVy0q9zMfP3TPkWHsr575vj
	tYM2xz3OH1x3dyVLt1LFgyrrxLgkngPvBesXLdm/cU7HL4k845p/1/Z6nFtwLOs2X6qRvoK9
	LIfdo/XxQn9KApUmNs+JOu/yuqPIomtFicSrWqOfD+dsqqr7zn5hvv38D0ulfs3bcUiJpTgj
	0VCLuag4EQBipUG4zwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd347ZHBBq+bmC3+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWoDi9yewWPQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi9uX
	eS3+3vnHZnHq+mc2i5N/ehktnhz+yGoxY/JLNov1M16zWBybsYTRov3vXjaLvTsnMzqIeayZ
	t4bRo6W5h83j969JjB5/V71g9tg56y67x51re9g8Ni+p97hyoonVo2/LKkaPz5vkAriiGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AeVVIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm3HtjVzBHvuL/LM8GxomSXYwcHBIC
	JhIrJyZ3MXICmWISF+6tZ+ti5OIQEpjOKHG57R0zhNPEJPH31h82kCo2AS2J/S9ugNkiAroS
	U2beYQWxmQVaWST6ttSA2MICfhIvHpwAq2ERUJWYfPotI4jNK+Aq8e/hImaIbXISH/Y8Yp/A
	yL2AkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBMP5PawbiyweIQowAHoxIP7we1yGAh
	1sSy4srcQ4wSHMxKIrzKq4BCvCmJlVWpRfnxRaU5qcWHGJOBtk9klhJNzgemm7ySeENjEzMj
	SyNzQwsjY3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYEzuZdmwLF5rH2Ne0D27q58W
	P3XKWlP9Uv/UMY2A+UEHfnFtOMnJwht1bcmrmKdLpgfdfbf/Bef0COeQWc7myT5XU4qb+Ovz
	rQo5ftpf4H/VMzvRWKxr96413aWu529rtlgKFT3aL3iih00jvcTZpEbq4YUXyQ1L40/p6vqW
	/7HmUjOfsJu5VYmlOCPRUIu5qDgRALIppZYtAwAA
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

[Pinctrl patch for Exynos3250]
The pinctrl patch for Exynos3250 has been merged in pinctrl.git of Linus Walleij
- [1] https://lkml.org/lkml/2014/4/23/72

This patchset is based on following git repo/branch.
- git repo : git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
- branch   : for-next (Linux 3.15-rc1)

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

 .../devicetree/bindings/clock/exynos3250-clock.txt |  41 +
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi          | 477 +++++++++++
 arch/arm/boot/dts/exynos3250.dtsi                  | 405 +++++++++
 arch/arm/boot/dts/exynos4212-tizenw.dts            | 926 +++++++++++++++++++++
 arch/arm/mach-exynos/Kconfig                       |  22 +
 arch/arm/mach-exynos/exynos.c                      |   2 +
 arch/arm/mach-exynos/firmware.c                    |  21 +-
 arch/arm/mach-exynos/hotplug.c                     |  19 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |  10 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos3250.c               | 785 +++++++++++++++++
 include/dt-bindings/clock/exynos3250.h             | 256 ++++++
 12 files changed, 2957 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos3250-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4212-tizenw.dts
 create mode 100644 drivers/clk/samsung/clk-exynos3250.c
 create mode 100644 include/dt-bindings/clock/exynos3250.h

-- 
1.8.0

