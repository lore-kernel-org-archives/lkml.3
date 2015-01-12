Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbbALP1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:27:45 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48802 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbbALP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:27:43 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Alexander Stein <alexanders83@web.de>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.19 #1 (ter)
Date: Mon, 12 Jan 2015 16:27:52 +0100
Message-ID: <1421076472-10589-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Here is the fixes pull-request for 3.19 that supersedes the ones already sent.
It collects all the fixes that I have currently for this kernel revision.

Thanks, best regards,

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-fixes

for you to fetch changes up to b8659752c37ec157ee254cff443b1c9d523aea22:

  ARM: at91: board-dt-sama5: add phy_fixup to override NAND_Tree (2015-01-12 15:50:23 +0100)

----------------------------------------------------------------
First fixes batch for AT91 on 3.19:
- fix some DT entries
- correct clock entry for the at91sam9263 LCD
- add a phy_fixup for Eth1 on sama5d4

----------------------------------------------------------------
Alexander Stein (1):
      ARM: at91/dt: sam9263: Add missing clocks to lcdc node

Bo Shen (2):
      ARM: at91/dt: sama5d4: fix the timer reg length
      ARM: at91: sama5d3: dt: correct the sound route

Wenyou Yang (1):
      ARM: at91: board-dt-sama5: add phy_fixup to override NAND_Tree

 arch/arm/boot/dts/at91sam9263.dtsi  |  2 ++
 arch/arm/boot/dts/sama5d3xmb.dtsi   |  2 +-
 arch/arm/boot/dts/sama5d4.dtsi      |  2 +-
 arch/arm/mach-at91/board-dt-sama5.c | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)

-- 
Nicolas Ferre
