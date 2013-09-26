Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3IZQ7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:59:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36289 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3IZQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:59:44 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-00-524467fed203
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        devicetree@vger.kernel.org, t.figa@samsung.com,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        k.debski@samsung.com, s.nawrocki@samsung.com, t.stanislaws@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [RFC 0/3]ARM: SAMSUNG: MACH S5PV210: Add support for Devicetree
Date: Thu, 26 Sep 2013 18:59:26 +0200
Message-id: <1380214769-7685-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jQd1/6S5BBivXqlhsnLGe1WL+kXOs
	FuderWS0+PH6AptF74KrbBabHl9jtbi8aw6bxYzz+5gsbl/mtTi95hSzxdojd9ktll6/yGQx
	YfpaFovDKw4wWRx+085q8epgG4vF+hmvWSzmtb9kdRDyWDNvDaNHS3MPm8eCz1fYPVYu/8Lm
	sXlJvcfBd3uYPPq2rGL0+LxJzmPj3NAAzigum5TUnMyy1CJ9uwSujJ3nTjMW3OWu2LD4JnsD
	4z3OLkZODgkBE4nb05eyQdhiEhfurQezhQSmM0pMu1zfxcgFZLczSfzreMwOkmATMJeY+GwT
	C4gtIiAp0dTwhxmkiFngKbPE2ZWfwYqEBTwkVl++zwhiswioSnx+MQ/M5hXwlZjfvJgRYpuC
	xM/LJ9gmMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcts+kdzCuarA4xCjAwajE
	w3uB2TlIiDWxrLgy9xCjBAezkgjv+liXICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE
	0hNLUrNTUwtSi2CyTBycUg2M/YkTTZQtl32etOd6c9OvyOkLpsmUpbQ2bGTh6fol/OrRnA3F
	sopxNlvZpt4QfKtsctBgXlP735nvjXW+P/CTZPHJuuN6Y1L627OSx/4br9x35OZHR55YZt0n
	setfrtgaHGXekxP8VU5rolHD8Y+JssLWrXOqV3290dRlYmRcZ2oR3xhRfKdJiaU4I9FQi7mo
	OBEA1i5241cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add initial device tree support for mach s5pv210.
It was tested on goni, aquila and tiny210.

Mateusz Krawczuk (3):
  ARM: s5pv210: Add board file for boot using Device Tree
  Samsung: DT: Add Device tree for s5pv210
  Samsung: DT: Add Device tree for S5PC110/S5PV210 Boards

 arch/arm/boot/dts/Makefile              |   6 +
 arch/arm/boot/dts/s5pv210-aquila.dts    | 407 ++++++++++++++++
 arch/arm/boot/dts/s5pv210-goni.dts      | 486 +++++++++++++++++++
 arch/arm/boot/dts/s5pv210-pinctrl.dtsi  | 820 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/s5pv210-smdkc110.dts  | 165 +++++++
 arch/arm/boot/dts/s5pv210-smdkv210.dts  | 273 +++++++++++
 arch/arm/boot/dts/s5pv210-tiny210.dts   | 262 ++++++++++
 arch/arm/boot/dts/s5pv210.dtsi          | 498 +++++++++++++++++++
 arch/arm/mach-s5pv210/Kconfig           |  14 +
 arch/arm/mach-s5pv210/Makefile          |   2 +-
 arch/arm/mach-s5pv210/mach-s5pv210-dt.c |  92 ++++
 11 files changed, 3024 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/s5pv210-aquila.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-goni.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkc110.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkv210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-tiny210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210.dtsi
 create mode 100644 arch/arm/mach-s5pv210/mach-s5pv210-dt.c

-- 
1.8.1.2

