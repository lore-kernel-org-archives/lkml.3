Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbbAZQTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:19:43 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:16988 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbbAZQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:19:40 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: dt for 3.20 #2
Date: Mon, 26 Jan 2015 17:19:50 +0100
Message-ID: <1422289190-29638-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Some more little modifications for the DT on several products. The
corresponding code in drivers is already queued in the relevant maintainers'
git trees and there are no dependencies.

Thanks, best regards,

The following changes since commit 4dd32e6d24932b0b0327d3a8ce526a56446e9b98:

  ARM: at91: dts: sama5d3: add ov2640 camera sensor support (2015-01-15 16:14:27 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-dt2

for you to fetch changes up to c7f85be1fdd130490b8b525b8f3a821a59e75feb:

  ARM: at91/dt: sam9263: Add ac97 device node (2015-01-26 17:00:04 +0100)

----------------------------------------------------------------
Second DT batch for 3.20:
- correct some pin configuration for at91sam9x5ek
- add pioD on sama5d4 following a modification of pinctrl driver
- add more precise nand compatibility string for sama5d4
- audio modifications for wm8904 or ac97

----------------------------------------------------------------
Alexander Morozov (1):
      ARM: at91: sama5d3xek/dt: use dt ids for wm8904

Alexander Stein (2):
      dt: atmel_ac97c: Add device tree documentation
      ARM: at91/dt: sam9263: Add ac97 device node

Bo Shen (1):
      ARM: at91: at91sam9n12ek/dt: use dt ids for wm8904

Josh Wu (1):
      ARM: at91: sama5d4: dts: change the nand compatible string

Ludovic Desroches (1):
      ARM: at91/dt: sama5d4: add pioD controller

Sylvain Rochet (1):
      ARM: at91/dt: disable pull-up on vbus-gpio (PB16) to reduce power consumption

 .../devicetree/bindings/sound/atmel_ac97c.txt       | 20 ++++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi                  | 21 +++++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12ek.dts                 |  2 +-
 arch/arm/boot/dts/at91sam9x5ek.dtsi                 |  9 +++++++++
 arch/arm/boot/dts/sama5d3xmb.dtsi                   |  2 +-
 arch/arm/boot/dts/sama5d4.dtsi                      | 15 ++++++++++++++-
 6 files changed, 66 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/atmel_ac97c.txt

-- 
Nicolas Ferre
