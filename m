Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaDUBKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 21:10:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60723 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaDUBK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 21:10:26 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-7e-53547000093c
Message-id: <53547006.8030307@samsung.com>
Date: Mon, 21 Apr 2014 10:10:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: kgene.kim@samsung.com
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org, t.figa@samsung.com,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv3 0/7] Support new Exynos3250 SoC based on Cortex-A7 dual
 core
References: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsWyRsSkUJehICTYoOWMoMXfScfYLSatO8Bk
	cXm/tsX1L89ZLeYfOcdq8flDC7tF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnX4u+d
	f2wWp65/ZrM4+aeX0eLJ4Y+sFjMmv2SzWD/jNYvFsRlLGC3a/+5ls9i7czKjg6jHmnlrGD1a
	mnvYPH7/msTo8XfVC2aPnbPusnvcubaHzWPzknqPKyeaWD36tqxi9Pi8SS6AK4rLJiU1J7Ms
	tUjfLoEr49ni3YwFOxUqvm29xt7A+FCyi5GTQ0LAROLI1S8sELaYxIV769m6GLk4hASWMkpc
	33mJHabo9qRpUInpjBJHD3xhgnBeM0pMuf0arIpXQEtiz5LjYKNYBFQlzj/fxwRiswHF97+4
	wQZiiwqESaycfoUFol5Q4sfke2C2iICkRFPDH2YQm1lgEovE8vdg5wkLhEjMbT8CFhcScJF4
	+H06WD2ngKvE+cdHWCDqdST2t05jg7DlJTavecsMcfUVDokPXSIQ9whIfJt8CKieAyguK7Hp
	AFSJpMTBFTdYJjCKzUJy0SwkU2chmbqAkXkVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmC6
	OP3v2cQdjPcPWB9iTAZaOZFZSjQ5H5hu8kriDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBcZEX85xsbr3sC31L/59539xVITU7J3aBtK+A9eqJFQfX
	9VvqSRdKnNjIpv9uSVCY+Q+Fyr2BmU8XiP74xnlQN6IlmSViy+Q7KpNfbD42t6Pl44IJNcsk
	E37tP2kaxvOm/njT7W31/D5nrULn3Xh1VY5ZsOvqeh1/x3DZJXMzG06V+fDF5CXYKbEUZyQa
	ajEXFScCAJJFcRItAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsVy+t9jQV2GgpBgg5t97BZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLewWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei793
	/rFZnLr+mc3i5J9eRosnhz+yWsyY/JLNYv2M1ywWx2YsYbRo/7uXzWLvzsmMDqIea+atYfRo
	ae5h8/j9axKjx99VL5g9ds66y+5x59oeNo/NS+o9rpxoYvXo27KK0ePzJrkArqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoB+VFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBnPFu9mLNipUPFt6zX2BsaHkl2MnBwSAiYS
	tydNY4OwxSQu3FsPZHNxCAlMZ5Q4euALE4TzmlFiyu3X7CBVvAJaEnuWHGcBsVkEVCXOP9/H
	BGKzAcX3v7gBNklUIExi5fQrLBD1ghI/Jt8Ds0UEJCWaGv4wg9jMApNYJJa/B7tCWCBEYm77
	EbC4kICLxMPv08HqOQVcJc4/PsICUa8jsb8V4lJmAXmJzWveMk9gFJiFZMUsJGWzkJQtYGRe
	xSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcjp5J7WBc2WBxiFGAg1GJh9cuOyRYiDWxrLgy
	9xCjBAezkgjvyZfBwUK8KYmVValF+fFFpTmpxYcYk4EhMJFZSjQ5H5gq80riDY1NzIwsjcwN
	LYyMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcdG5lcfEn+0ITnubVSnLcO2f+MSL
	u/1fSv19XmLyojerM1Hn5uL/xsoFAvwfP/lZPMnaLlbR5clfnnSE86lNzpsVtyPu9idKfItv
	zXovG8Wsd7tDzTut8oyro/HK3k3vjl6fyTplwYYcF/l+FbcOycuPAxYyaSTVLS+uvmXzaC7T
	9deRzXnOSizFGYmGWsxFxYkADnajQIsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

Please review this patchset for Exynos3250 SoC.

Best Regards,
Chanwoo Choi

On 04/18/2014 10:15 AM, Chanwoo Choi wrote:
> This patchset support new Exynos3250 Samsung SoC based on Cortex-A7 dual core.
> Exynos3250 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
> for Smartphone. It is desigend with the 28nm low-power high-K metal gate process
> and provides the best performance features.
> 
> This patchset include some patches such as:
> - Support secondary CPU of Exynos3250 (cpu up/down)
> - Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/pwm/amba
> - Support the clock control for Exynos3250 using common clk framework
> 
> This patchset is based on following git repo/branch.
> - git repo : git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> - branch   : for-next (Linux 3.15-rc1)
> 
> Additional patch description about static memory mapping:
> This patchset must need to map memory mapping about SYSRAM/PMU for CPU UP/DOWN.
> So, this patchset need to merge following patchset to remove static memory
> mapping for SYSRAM[1] / PMU ([2] or [3]).
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg323011.html
> [2] https://lkml.org/lkml/2014/4/2/48
> [3] http://www.spinics.net/lists/arm-kernel/msg316013.html
> 
> And,
> The pinctrl patch for Exynos3250 was posted as separated patch[4].
> [4] https://lkml.org/lkml/2014/4/13/156
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
> Chanwoo Choi (4):
>   ARM: EXYNOS: Add Exynos3250 SoC ID
>   ARM: EXYNOS: Support secondary CPU boot of Exynos3250
>   ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250 based on Cortex-a7
>   dt-bindings: add documentation for Exynos3250 clock controller
> 
> Kyungmin Park (1):
>   ARM: EXYNOS: Support secondary CPU boot of Exynos4212
> 
> Tomasz Figa (2):
>   clk: samsung: exynos3250: Add clocks using common clock framework
>   ARM: dts: Add device tree sources for Exynos3250
> 
>  .../devicetree/bindings/clock/exynos3250-clock.txt |  41 ++
>  arch/arm/boot/dts/exynos3250-pinctrl.dtsi          | 477 +++++++++++++
>  arch/arm/boot/dts/exynos3250.dtsi                  | 427 +++++++++++
>  arch/arm/mach-exynos/Kconfig                       |  22 +
>  arch/arm/mach-exynos/exynos.c                      |   2 +
>  arch/arm/mach-exynos/firmware.c                    |  21 +-
>  arch/arm/mach-exynos/hotplug.c                     |  19 +-
>  arch/arm/plat-samsung/include/plat/cpu.h           |  10 +
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos3250.c               | 785 +++++++++++++++++++++
>  include/dt-bindings/clock/exynos3250.h             | 256 +++++++
>  11 files changed, 2053 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/exynos3250-clock.txt
>  create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>  create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
>  create mode 100644 drivers/clk/samsung/clk-exynos3250.c
>  create mode 100644 include/dt-bindings/clock/exynos3250.h
> 

