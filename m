Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaEOE2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:28:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42812 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOE2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:28:31 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-db-5374426c42c4
Message-id: <5374426B.6000505@samsung.com>
Date: Thu, 15 May 2014 13:28:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: kgene.kim@samsung.com
Cc: Chanwoo Choi <cw00.choi@samsung.com>, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ben-linux@fluff.org, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv5 0/5] Support new Exynos3250 SoC based on Cortex-A7 dual
 core
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsWyRsSkSDfHqSTY4N1PJYu/k46xW0xad4DJ
	4vJ+bYvrX56zWsw/co7V4vOHFqD4/QksFr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZl
	Xou/d/6xWZy6/pnN4uSfXkaLJ4c/slrMmPySzWL9jNcsFsdmLGG0aP+7l81i787JjA5iHmvm
	rWH0aGnuYfP4/WsSo8ffVS+YPXbOusvucefaHjaPzUvqPa6caGL16NuyitHj8ya5AK4oLpuU
	1JzMstQifbsEroyzG98yF9xVrng+tbKB8aBMFyMnh4SAicT1d5dYIGwxiQv31rN1MXJxCAks
	ZZTYuuYWI0zR/HlzWCASixglOqdfZYdwXjNKzFzSwgxSxSugJTF912Ugm4ODRUBVYvtnL5Aw
	G1B4/4sbbCC2qECYxMrpV1ggygUlfky+B2aLCEhKNDX8ARvDLLCCReLX81IQW1ggROJAyyyw
	XiEBV4llZ+8ygdicAm4Sv263sEPU60jsb53GBmHLS2xe85YZ4ugbHBJH/xuC2CwCAhLfJh9i
	ATlNQkBWYtMBqBJJiYMrbrBMYBSbheSiWUimzkIydQEj8ypG0dSC5ILipPQiY73ixNzi0rx0
	veT83E2MwKRx+t+z/h2Mdw9YH2JMBlo5kVlKNDkfmHTySuINjc2MLExNTI2NzC3NSBNWEue9
	/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjb1n3I9l7RyYmea6ddq4lwZRr+qbmuREP
	kiL6/r3KmTwz5Ilq0tVdMc/9Fh+tn33Za0l4d99B+bSWhZ75LXXnwjdYhuYlOtsuXqt7/HXV
	fV/WChPjkHWr6wxMWC/p9b6/qSuytyh3oVL1A4UnHlmrDvTpLE+VD7Jb0iT8IvSlPV+mqspb
	9pVKLMUZiYZazEXFiQDi7pXnMAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jAd0cp5Jgg8WTxC3+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWoDi9yewWPQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi9uX
	eS3+3vnHZnHq+mc2i5N/ehktnhz+yGoxY/JLNov1M16zWBybsYTRov3vXjaLvTsnMzqIeayZ
	t4bRo6W5h83j969JjB5/V71g9tg56y67x51re9g8Ni+p97hyoonVo2/LKkaPz5vkAriiGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AeVVIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmnN34lrngrnLF86mVDYwHZboYOTkk
	BEwk5s+bwwJhi0lcuLeerYuRi0NIYBGjROf0q+wQzmtGiZlLWphBqngFtCSm77oMZHNwsAio
	Smz/7AUSZgMK739xgw3EFhUIk1g5/QoLRLmgxI/J98BsEQFJiaaGP2BjmAVWsEj8el4KYgsL
	hEgcaJkF1isk4Cqx7OxdJhCbU8BN4tftFnaIeh2J/a3T2CBseYnNa94yT2AUmIVkxSwkZbOQ
	lC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZyUnkntYFzZYHGIUYCDUYmHl2FycbAQ
	a2JZcWXuIUYJDmYlEV4TxpJgId6UxMqq1KL8+KLSnNTiQ4zJwACYyCwlmpwPTJh5JfGGxiZm
	RpZG5oYWRsbmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cBoFZt970Im269m3hfyc212
	K0s2r9oqHpK+WXV+7i2l7Zt+Ba2KSPz8bfkPudl1aTnVl9Vfmsyo2Cl2ysIs+PBKTXO7FX1f
	vmokThcO9W33PsgY+iNP7VamUunKXPGVOq/k3O0ZtEqsKqKdnnc5NXGbl8Qnh/jGb637/fH9
	zokSQW1xPPFp2kosxRmJhlrMRcWJAIKAaKmOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

Could you please pick following patches?
- [PATCHv5 1/5] ARM: EXYNOS: Add Exynos3250 SoC ID
- [PATCHv5 2/5] ARM: EXYNOS: Support secondary CPU boot of Exynos3250

Best Regards,
Chanwoo Choi

On 05/13/2014 10:05 PM, Chanwoo Choi wrote:
> This patchset support new Exynos3250 Samsung SoC based on Cortex-A7 dual core.
> Exynos3250 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
> for Smartphone. It is desigend with the 28nm low-power high-K metal gate process
> and provides the best performance features.
> 
> This patchset include some patches such as:
> - Support booting of Exynos3250
> - Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/pwm/amba
> - Support the clock control for Exynos3250 using common clk framework
> 
> This patchset is based on following git repo/branch.
> - git repo : git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> - branch   : for-next (2ca8b247775d7c24fa8c2524a5562bad7e88f84b)
> 
> Changes from v4:
> - Rebase this patch on latest for-next branch in linux-samsung.git
> - Post separated secondary CPU boot patch for Exynos4212 and merged it
>  : https://lkml.org/lkml/2014/5/8/745
> - Drop following patch[1] and use alternative patch[2] to turn off Cortex-A7
>   [1] ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7
>   [2] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg29064.html
> - Modify clock driver of exynos3250
> - Add 'soc' dt node and move all dt nodes under 'soc' dt node in exynos3250.dtsi
> - Add missing CPU1 dt node in exynos3250.dtsi
> - Fix minor issue about coding style
> 
> Changes from v3:
> - Remove all dependency about following patchset to remove static memory
>   mapping for SYSRAM[1] / PMU ([2] or [3]). If following patchset merged,
>   I'll send a further patches to support SYSRAM/PMU for secondary CPU.
>   [1] http://www.spinics.net/lists/arm-kernel/msg323011.html
>   [2] https://lkml.org/lkml/2014/4/2/48
>   [3] http://www.spinics.net/lists/arm-kernel/msg316013.html
> 
> Changes from v2:
> - Remove static memory mapping about SYSRAM/PMU such as following patches:
>   ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of Exynos3250
>   ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
> - Add description for secondary CPU boot of Exynos4212/Exynos3250
> - Fix description in exynos_cpu_die() to remove particular SoC series
> - Fix minor coding style
> - Add documentation for Exynos3250 clock controller
> 
> Changes from v1:
> - Add new "samsung,exynos3" compatible name
> - Add comment about exynos_cpu_boot in Exynos4212
> - Remove unnecessary 'goto' statement in firmware.c
> - Use read_cpuid_part_number() function instead of assembler directly
> - Post separated pinctrl patch from this patchset
>   : https://lkml.org/lkml/2014/4/13/156
> - Remove unused pmu interrupts due to Exynos3250 dual-core
> - Cosolidate all the patches related to exynos3250.dtsi into one patch
> - Fix gic compatible name to "cortex-a15-gic" because Cortex-A7 GIC is same
> - Add sign-off of sender to all this patches
> - Fix minor typo
> 
> Chanwoo Choi (3):
>   ARM: EXYNOS: Add Exynos3250 SoC ID
>   ARM: EXYNOS: Support secondary CPU boot of Exynos3250
>   dt-bindings: add documentation for Exynos3250 clock controller
> 
> Tomasz Figa (2):
>   clk: samsung: exynos3250: Add clocks using common clock framework
>   ARM: dts: Add device tree sources for Exynos3250
> 
>  .../devicetree/bindings/clock/exynos3250-clock.txt |  41 ++
>  arch/arm/boot/dts/exynos3250-pinctrl.dtsi          | 475 +++++++++++++
>  arch/arm/boot/dts/exynos3250.dtsi                  | 439 ++++++++++++
>  arch/arm/mach-exynos/Kconfig                       |  22 +
>  arch/arm/mach-exynos/common.h                      |  10 +
>  arch/arm/mach-exynos/exynos.c                      |   2 +
>  arch/arm/mach-exynos/firmware.c                    |   9 +-
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos3250.c               | 782 +++++++++++++++++++++
>  include/dt-bindings/clock/exynos3250.h             | 258 +++++++
>  10 files changed, 2038 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/exynos3250-clock.txt
>  create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>  create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
>  create mode 100644 drivers/clk/samsung/clk-exynos3250.c
>  create mode 100644 include/dt-bindings/clock/exynos3250.h
> 

