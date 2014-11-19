Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaKSQwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:52:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:15911 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaKSQwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:52:35 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: dt for 3.19 #2
Date: Wed, 19 Nov 2014 17:52:33 +0100
Message-ID: <1416415953-31966-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Another DT pull-request for 3.19. For this one, I had to pull one Vinod's topic
branch to be able to include the XDMA DT properties. This branch is stable and
based on 3.18-rc3 (Cf. http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/304041.html).
Note that my previous DT pull-request for 3.19 was based on 3.18-rc2.
So, this is what I did:
- took a v3.18-rc3 tag
- merged the at91-3.19-dt branch that you already have in at91/dt (you'd taken the at91-dt tag)
- merged the topic/at_xdmac from Vinod
- stacked the new material described above on top of this.
Tell me if it's okay for you or if I have to arrange things differently.

The content itself is pretty straightforward.

Thanks, best regards,

The following changes since commit 51f46e5bc326972f623cad7ac9dadc3cf8159203:

  Merge branch 'topic/at_xdmac' of git://git.infradead.org/users/vkoul/slave-dma into at91-3.19-dt2 (2014-11-19 12:11:30 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-dt2

for you to fetch changes up to accda2736fcab10fc3eb35da935e0e049188f6d5:

  ARM: at91/dt: at91sam9g45: add ISI node (2014-11-19 15:55:17 +0100)

----------------------------------------------------------------
Second DT batch for 3.19:
- some trivial fixes: macro for IRQ, license wording
- DMA description for sama5d4
- RTT as RTC driver definition plus associated GPBR for several SoCs
- addition of missing nodes: rtc for at91sam9rl, isi for at91sam9g45

----------------------------------------------------------------
Alexandre Belloni (1):
      ARM: at91/dt: at91sam9rl: add rtc

Boris Brezillon (5):
      ARM: at91/dt: add RTT nodes to at91 dtsis
      ARM: at91/dt: add GPBR nodes
      ARM: at91/dt: enable the RTT block on the sam9g20ek board
      ARM: at91/dt: enable the RTT block on the at91sam9m10g45ek board
      ARM: at91/dt: at91sam9g45: add ISI node

Ludovic Desroches (2):
      ARM: at91/dt: sama5d4: use macro instead of numeric value
      ARM: at91/dt: sama5d4: add DMA support

Nicolas Ferre (1):
      ARM: at91: fix GPLv2 wording

 arch/arm/boot/dts/at91-sama5d4ek.dts        |  4 +-
 arch/arm/boot/dts/at91sam9260.dtsi          | 14 ++++++
 arch/arm/boot/dts/at91sam9261.dtsi          | 14 ++++++
 arch/arm/boot/dts/at91sam9263.dtsi          | 21 ++++++++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi | 14 ++++++
 arch/arm/boot/dts/at91sam9g45.dtsi          | 46 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts      |  9 ++++
 arch/arm/boot/dts/at91sam9rl.dtsi           | 21 ++++++++
 arch/arm/boot/dts/sama5d4.dtsi              | 75 +++++++++++++++++++++++++++--
 9 files changed, 213 insertions(+), 5 deletions(-)

-- 
Nicolas Ferre
