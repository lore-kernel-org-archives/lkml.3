Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaDOB7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:59:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28212 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaDOB7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:59:52 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-8d-534c92963718
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv2 0/8] Support new Exynos3250 SoC based on Cortex-A7 dual core
Date: Tue, 15 Apr 2014 10:59:44 +0900
Message-id: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkUHfaJJ9gg7YJShZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLewWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei793
	/rFZnLr+GSg0+SWbxfoZr1ksjs1Ywmixd+dkRgchjzXz1jB6tDT3sHn8/jWJ0ePvqhfMHneu
	7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC+CM4rJJSc3JLEst0rdL4MpYeG0CW8FlqYqpr9exNDC+
	Fu1i5OSQEDCROLR+ATuELSZx4d56ti5GLg4hgaWMEl/m7mCDKXq1uBEqsYhR4nP3aRYIp4lJ
	4vmRw0wgVWwCWhL7X9wA6xARUJDY3PuMFaSIWWAts8TFSY1gCWEBP4mFq3aB7WMRUJV4vOkr
	WDOvgKvE33c/odbJSXzY84gdpFlC4CW7xP7da5kgGgQkvk0+BLSaAyghK7HpADNEvaTEwRU3
	WCYwCi5gZFjFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERhLp/89693BePuA9SHGZKBxE5ml
	RJPzgbGYVxJvaGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2MnnlP7P7XSV1fsWLNp7QvKi3vLrW4PtSMsTz4Luep+JOM/KI191bYTF5T8Ok9q1zrkwbL
	j593zPgRd1SXKWBqKvcCkWMB3HI2rEdf7ViYriHvMvPnjfu3rB7sTFeUvO5feykznvVoAsO8
	wlfXd4pbznxnIbGO75kOi8nOVZHhKy2Dn8/0Cf99TYmlOCPRUIu5qDgRAJ/NG2m7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xgO60ST7BBm+nSVj8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tLBb9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5Lf7e
	+cdmcer6Z6DQ5JdsFutnvGaxODZjCaPF3p2TGR2EPNbMW8Po0dLcw+bx+9ckRo+/q14we9y5
	tofNY/OSeo8rJ5pYPfq2rGL0+LxJLoAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1G
	BmggYQ1jxsJrE9gKLktVTH29jqWB8bVoFyMnh4SAicSrxY1sELaYxIV764FsLg4hgUWMEp+7
	T7NAOE1MEs+PHGYCqWIT0JLY/+IGWIeIgILE5t5nrCBFzAJrmSUuToIYJSzgJ7Fw1S52EJtF
	QFXi8aavYM28Aq4Sf9/9hFonJ/FhzyP2CYzcCxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefn
	bmIER+ozqR2MKxssDjEKcDAq8fB6TPAJFmJNLCuuzD3EKMHBrCTC+zoZKMSbklhZlVqUH19U
	mpNafIgxGWj7RGYp0eR8YBLJK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFq
	EcwWJg5OqQZGpm9TrGqMl26Lj2BY2dD5el1RrXfyNTfJle8VNuqKNDBVNu6a2j/lSStnuKSz
	yp7mM+LSYVltfEpv4o3FCwqO/n3aUMtaO2HZNWZL+ZVaX4667quI95HZu8f5avnjPKHZKmpd
	Ov5bDBwDbu33M68/Ff7byT38yRsWvsNSmizbWevyj79YaajEUpyRaKjFXFScCACjhXmSGAMA	AA==
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

This patchset is completely tested and is based on following git repo/branch.
- git repo : git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
- branch   : for-next (Linux 3.15-rc1)

Additional patch description about static memory mapping:
Arnd Bergmann suggested that need proper driver instead of static memory mapping.
As Chanho Park reply[2], Sachin Kamat already posted the DT support patch[1]
for memory mapping for SYSRAM.
[1] http://www.spinics.net/lists/linux-samsung-soc/msg27647.html
[2] https://lkml.org/lkml/2014/4/10/161

So, I'm going to re-implement following patches related to static memory mapping
after merged Sachin Kamat patch[1].
  ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of Exynos3250
  ARM: EXYNOS: Add IO mapping for PMU of Exynos3250

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

Chanwoo Choi (5):
  ARM: EXYNOS: Add Exynos3250 SoC ID
  ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of Exynos3250
  ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
  ARM: EXYNOS: Support secondary CPU boot of Exynos3250
  ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7

Kyungmin Park (1):
  ARM: EXYNOS: Support secondary CPU boot of Exynos4212

Tomasz Figa (2):
  clk: samsung: exynos3250: Add clocks using common clock framework
  ARM: dts: Add device tree sources for Exynos3250

 arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 ++++++++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi         | 410 ++++++++++++++++
 arch/arm/mach-exynos/Kconfig              |  22 +
 arch/arm/mach-exynos/exynos.c             |  19 +
 arch/arm/mach-exynos/firmware.c           |  18 +-
 arch/arm/mach-exynos/hotplug.c            |  16 +-
 arch/arm/mach-exynos/include/mach/map.h   |   2 +
 arch/arm/plat-samsung/include/plat/cpu.h  |  10 +
 drivers/clk/samsung/Makefile              |   1 +
 drivers/clk/samsung/clk-exynos3250.c      | 785 ++++++++++++++++++++++++++++++
 include/dt-bindings/clock/exynos3250.h    | 256 ++++++++++
 11 files changed, 2010 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos3250.c
 create mode 100644 include/dt-bindings/clock/exynos3250.h

-- 
1.8.0

