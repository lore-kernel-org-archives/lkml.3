Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423346Ab3FUQZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:25:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423064Ab3FUQZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:25:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: ARM: SoC fixes for 3.10-rc
Date: Fri, 21 Jun 2013 18:25:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306211825.37495.arnd@arndb.de>
X-Provags-ID: V02:K0:1UBE8svXTGlJnQ9cUvS7uD1i02BlvkBiWHW/EASDsOk
 b0+lK7fudf7J/x+CQg/1WehJPcvVeqLxLTKt500XdpaOyL+Ylq
 A+Z4Cb4FxVUrRnjgjOOIbZWgOnXUH0MB0uLtaAb6XPopk3jbze
 mGMBYsKVVZp/UWsS7QNe1SQ6qQmp+bfzfPYI0/dfT8rly6pIyj
 4bB7t6Hhi/4az6dhIaAu8DdMrTjrSTOmwu/FaUPfmmbj1YSI3J
 b4lKSn+92oASeKYl1JSMvZD6dCfVPEQCQYr78R6hAuc2nXyzzT
 ZX8xtCYC0YuM53QkHtPaPIV7XiphshzUq5viS8htinTgH0qNjN
 MK+Rd/yUqgWa8ot/QDac=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 323226bbb3d865af12644d66df2b7f161adf51c7:

  Merge tag 'fixes-3.10-4' of git://git.infradead.org/users/jcooper/linux into fixes (2013-06-11 17:05:56 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 8b6fd652641e5ab1892d092e73e83d49291ed638:

  irqchip: gic: call gic_cpu_init() as well in CPU_STARTING_FROZEN case (2013-06-20 14:52:23 +0200)

----------------------------------------------------------------
ARM: SoC fixes for 3.10-rc

These are two fixes that came in this week, one for a regression we
introduced in 3.10 in the GIC interrupt code, and the other one
fixes a typo in newly introduced code.

----------------------------------------------------------------
Padmavathi Venna (1):
      ARM: dts: Correct the base address of pinctrl_3 on Exynos5250

Shawn Guo (1):
      irqchip: gic: call gic_cpu_init() as well in CPU_STARTING_FROZEN case

 arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 2 +-
 arch/arm/boot/dts/exynos5250.dtsi         | 4 ++--
 drivers/irqchip/irq-gic.c                 | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
