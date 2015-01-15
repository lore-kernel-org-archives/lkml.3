Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbbAOQwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:52:11 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10307 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbbAOQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:52:09 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <alexanders83@web.de>, <josh.wu@atmel.com>, <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: dt for 3.20 #1
Date: Thu, 15 Jan 2015 17:52:18 +0100
Message-ID: <1421340738-13487-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Some Device Tree updates for 3.20. There is no dependency for this material as
the drivers are already updated or not needed (syscon).

Thanks, best regards,

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-dt

for you to fetch changes up to 4dd32e6d24932b0b0327d3a8ce526a56446e9b98:

  ARM: at91: dts: sama5d3: add ov2640 camera sensor support (2015-01-15 16:14:27 +0100)

----------------------------------------------------------------
First batch of DT changes for 3.20:
- little typo and a LED declared
- addition of the Special Function Registers (SFR) + its binding
- RTC & SRAM nodes
- the at91sam9xe has its own .dtsi now. Not combined with at91sam9260 anymore
- addition of the Image Sensor Interface (ISI) DT part and supported sensors

----------------------------------------------------------------
Alexander Stein (1):
      ARM: at91/dt: sam9263: Fix typo: ac91_clk -> ac97_clk

Alexandre Belloni (9):
      ARM: at91: Add Special Function Registers binding documentation
      ARM: at91: sama5d3: Add SFR
      ARM: at91: sama5d4: Add SFR
      ARM: at91/dt: at91sam9n12: Add RTC node
      ARM: at91/dt: rm9200: add RTC node
      ARM: at91/dt: at91rm9200ek: enable RTC
      ARM: at91/dt: add SRAM nodes
      ARM: at91/dt: Add a dtsi for at91sam9xe
      ARM: at91/dt: ethernut5: use at91sam9xe.dtsi

Bo Shen (3):
      ARM: at91: dts: sama5d3: split isi pinctrl
      ARM: at91: dts: sama5d3: add missing pins of isi
      ARM: at91: dts: sama5d3: move the isi mck pin to mb

Josh Wu (5):
      ARM: at91/dt: sama5d3: enable D2 as the heartbeat LED
      ARM: at91: dts: sama5d3: add isi clock
      ARM: at91: dts: sama5d3: change name of pinctrl_isi_{power,reset}
      ARM: at91: dts: sama5d3: change name of pinctrl of ISI_MCK
      ARM: at91: dts: sama5d3: add ov2640 camera sensor support

 .../devicetree/bindings/arm/atmel-at91.txt         | 17 ++++++
 arch/arm/boot/dts/at91rm9200.dtsi                  | 12 +++++
 arch/arm/boot/dts/at91rm9200ek.dts                 |  4 ++
 arch/arm/boot/dts/at91sam9260.dtsi                 |  5 ++
 arch/arm/boot/dts/at91sam9261.dtsi                 |  5 ++
 arch/arm/boot/dts/at91sam9263.dtsi                 | 12 ++++-
 arch/arm/boot/dts/at91sam9g20.dtsi                 |  9 ++++
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  7 ++-
 arch/arm/boot/dts/at91sam9n12.dtsi                 | 12 +++++
 arch/arm/boot/dts/at91sam9rl.dtsi                  |  5 ++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  5 ++
 arch/arm/boot/dts/at91sam9xe.dtsi                  | 60 ++++++++++++++++++++++
 arch/arm/boot/dts/ethernut5.dts                    |  2 +-
 arch/arm/boot/dts/sama5d3.dtsi                     | 34 ++++++++++--
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |  1 +
 arch/arm/boot/dts/sama5d3xmb.dtsi                  | 40 +++++++++++++--
 arch/arm/boot/dts/sama5d4.dtsi                     | 10 ++++
 17 files changed, 227 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9xe.dtsi

-- 
Nicolas Ferre
