Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaIARjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:39:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19376 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaIARjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:39:37 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL 4/4] at91: dt for 3.18 #2
Date: Mon, 1 Sep 2014 19:38:47 +0200
Message-ID: <1409593127-24049-4-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com>
References: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com>
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

A little bit more material for the DT branch. I didn't want to the one I've
just sent you because this material is not related to the big cleanup addressed
by previous 3 pull-requests.
It is very basic and simple DT updates and a use of phy fixup infrastructure
that is now present in phy subsystem.

Thanks, best regards,

The following changes since commit 464d6e18639c4347dafd8dbcee270674dd3d8fba:

  Merge tag 'at91-dt-for-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/mripard/linux (2014-08-19 16:04:10 -0500)

are available in the git repository at:


  git://github.com/at91linux/linux-at91.git tags/at91-dt2

for you to fetch changes up to 5f8157309624929e05ece846d3ca8a3a64988378:

  ARM: at91: remove phy fixup for sama5d3xek boards (2014-09-01 19:30:44 +0200)

----------------------------------------------------------------
Second batch of AT91 DT patches for 3.18:
- 2 little fixes for at91sam9x5 and at91sam9n12ek
- removal of a board specific hook for sama5d3xek about phy fixup
  replaced with proper DT property definition.

----------------------------------------------------------------
Alexandre Belloni (1):
      ARM: at91/dt: sam9x5: fix ADC compatible string

Bo Shen (1):
      ARM: at91/dt: sam9n12ek: ohci: add port and vbus property

Boris BREZILLON (2):
      ARM: at91/dt: describe rgmii ethernet phy connected to sama5d3xek boards
      ARM: at91: remove phy fixup for sama5d3xek boards

 arch/arm/boot/dts/at91sam9n12ek.dts |  2 ++
 arch/arm/boot/dts/at91sam9x5.dtsi   |  2 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi   | 30 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-dt-sama5.c | 22 ----------------------
 4 files changed, 33 insertions(+), 23 deletions(-)

-- 
Nicolas Ferre
