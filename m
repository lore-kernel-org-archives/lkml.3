Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3HZJlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:41:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:10088 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3HZJlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:41:10 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Josh Wu <josh.wu@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: device tree update for 3.12 #2
Date: Mon, 26 Aug 2013 11:41:02 +0200
Message-ID: <1377510062-14886-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is a second update on the DT front for AT91 on 3.12. This series is
stacked on top of patches that are already included in your at91/dt branch.

The inclusion of these Nand Flash Controller properties in DT are related to
the driver enhancement that is already queued in MTD tree:
http://git.infradead.org/linux-mtd.git/commit/7dc37de7d59cdd1c4cdd472e1994c31b16d7b874

Thanks, best regards,

The following changes since commit 90d01929ad38259596371c78df8a9ecf37a7f815:

  ARM: at91/dt: sam9x5ek: add sound configuration (2013-08-21 13:33:44 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt

for you to fetch changes up to afa6a2a726766d8145dc87f47073c745aa0f0d01:

  ARM: at91/dt: sama5d3xek: reduce the ROM code mapping for pmecc lookup table (2013-08-23 14:47:22 +0800)

----------------------------------------------------------------
AT91 DT changes for 3.12, take 2
- addition of the Nand Flash Controller (NFC) in DT
  for sama5d3 SoC. This NFC will enhance the traditional
  Nand Flash handling (SMC + PMECC).

----------------------------------------------------------------
Josh Wu (3):
      ARM: at91/dt: sama5d3xek: remove the useless NFC dt parameters
      ARM: at91/dt: sama5d3xek: Enable NFC support in dts
      ARM: at91/dt: sama5d3xek: reduce the ROM code mapping for pmecc lookup table

 arch/arm/boot/dts/sama5d3.dtsi    | 19 ++++++++++++++-----
 arch/arm/boot/dts/sama5d3xcm.dtsi |  2 --
 2 files changed, 14 insertions(+), 7 deletions(-)

-- 
Nicolas Ferre
