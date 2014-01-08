Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaAHOXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:23:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:45957 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbaAHOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:23:12 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: cleanup for 3.14 #2
Date: Wed, 8 Jan 2014 15:23:09 +0100
Message-ID: <1389190989-8261-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

A little "cleanup" pull-request for 3.14 that goes on top of the previous
AT91 cleanup material.
The thing to note from this pull-request is the beginning of board file removal
thank to the conversion to DT. We are still waiting for more feedback from
board maintainer to intensify the effort.

Thanks, best regards,

The following changes since commit b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:

  ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup2

for you to fetch changes up to e91a5555df5883bbc204b0e1f8e0489d3f7f3f2e:

  ARM: at91: switch Calao QIL-A9260 board to DT (2013-12-19 17:27:30 +0100)

----------------------------------------------------------------
Second cleanup pull-request for 3.14:
- a tiny fix for the recent AT91 CCF implementation
- the switch of one platform to DT with board file removal

----------------------------------------------------------------
Boris BREZILLON (1):
      clk: at91: fix pmc_clk_ids data type attriubte

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: switch Calao QIL-A9260 board to DT

 arch/arm/boot/dts/Makefile                  |   1 +
 arch/arm/boot/dts/at91-qil_a9260.dts        | 185 +++++++++++++++++++
 arch/arm/configs/at91sam9260_9g20_defconfig |   1 -
 arch/arm/mach-at91/Kconfig.non_dt           |   6 -
 arch/arm/mach-at91/Makefile                 |   1 -
 arch/arm/mach-at91/board-qil-a9260.c        | 266 ----------------------------
 drivers/clk/at91/pmc.c                      |   2 +-
 7 files changed, 187 insertions(+), 275 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91-qil_a9260.dts
 delete mode 100644 arch/arm/mach-at91/board-qil-a9260.c

-- 
Nicolas Ferre
