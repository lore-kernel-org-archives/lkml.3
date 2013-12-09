Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab3LIJ5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:57:43 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:14015 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab3LIJ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:57:42 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <Josh.wu@atmel.com>, Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: soc updates for 3.14 #1
Date: Mon, 9 Dec 2013 10:57:39 +0100
Message-ID: <1386583059-22281-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This pull-request is for addition of sama5d36 and its Evaluation Kit. The
patches are stacked on the "cleanup" material already in arm-soc tree
(at91/sama5-ccf) like all other AT91 pull-requests for 3.14.

Thanks, best regards,

The following changes since commit b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:

  ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-soc

for you to fetch changes up to 0a72922b8dab2a1ce9cc977e9b1850556b48b4aa:

  ARM: at91: sama5d3/dt: add sama5d36ek dts files (2013-12-09 09:50:53 +0100)

----------------------------------------------------------------
First soc pull-request for 3.14
Addition of the sama5d36 SoC as a member of the sama5d3 family
- SoC code and Device Tree file
- Evaluation Kit (EK board) Device Tree file

----------------------------------------------------------------
Josh Wu (2):
      ARM: at91: sama5d3: add support for sama5d36 chip
      ARM: at91: sama5d3/dt: add sama5d36ek dts files

 arch/arm/boot/dts/Makefile            |  2 ++
 arch/arm/boot/dts/sama5d3.dtsi        |  2 +-
 arch/arm/boot/dts/sama5d36.dtsi       | 20 +++++++++++++
 arch/arm/boot/dts/sama5d36ek.dts      | 53 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/Kconfig            |  2 +-
 arch/arm/mach-at91/include/mach/cpu.h |  3 +-
 arch/arm/mach-at91/setup.c            |  4 +++
 7 files changed, 83 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/dts/sama5d36.dtsi
 create mode 100644 arch/arm/boot/dts/sama5d36ek.dts

-- 
Nicolas Ferre
