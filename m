Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaDRVwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:52:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11781 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaDRVwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:52:40 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [GIT PULL] at91: fixes for 3.15 #1
Date: Fri, 18 Apr 2014 23:52:38 +0200
Message-ID: <1397857958-11283-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Two little fixes for AT91. The one that moves the dt-bindings include
directory is pretty interesting as, with Exynos, AT91 was the only one
to use this "clk" directory.

Thanks, best regards,

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 35d35aae817706800a4913711d563a99e1dc380a:

  dt-bindings: clock: Move at91.h to dt-bindigs/clock (2014-04-18 23:44:52 +0200)

----------------------------------------------------------------
3.15 fixes for AT91
- one little DT fix
- the use of proper directory for clock in include/dt-bindings
  it allows to remove the now empty include/dt-bindings/clk

----------------------------------------------------------------
Bo Shen (1):
      ARM: at91: fix spi cs on sama5d3 Xplained board

Tushar Behera (1):
      dt-bindings: clock: Move at91.h to dt-bindigs/clock

 Documentation/devicetree/bindings/clock/at91-clock.txt | 2 +-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts            | 4 ++--
 arch/arm/boot/dts/at91sam9261.dtsi                     | 2 +-
 arch/arm/boot/dts/at91sam9rl.dtsi                      | 2 +-
 arch/arm/boot/dts/sama5d3.dtsi                         | 2 +-
 arch/arm/boot/dts/sama5d3_mci2.dtsi                    | 2 +-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                    | 2 +-
 arch/arm/boot/dts/sama5d3_uart.dtsi                    | 2 +-
 include/dt-bindings/{clk => clock}/at91.h              | 0
 9 files changed, 9 insertions(+), 9 deletions(-)
 rename include/dt-bindings/{clk => clock}/at91.h (100%)

-- 
Nicolas Ferre
