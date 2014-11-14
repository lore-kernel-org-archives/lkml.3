Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965243AbaKNLLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:11:31 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:29659 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965139AbaKNLLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:11:30 -0500
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
Subject: [GIT PULL] at91: fixes for 3.18 #2
Date: Fri, 14 Nov 2014 12:11:22 +0100
Message-ID: <1415963482-16582-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

I don't have more for the moment, so here is trivial at91 material for 3.18.

Thanks, best regards,

The following changes since commit 106c67af2fb938880edbf43b49dabbd8d2534839:

  ARM: at91/dt: sam9263: fix PLLB frequencies (2014-10-22 10:08:22 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-fixes2

for you to fetch changes up to c4e4bbcee9fa37024a2d4cdcaa5fe89a2c5c7a05:

  ARM: at91/dt: Fix sama5d3x typos (2014-11-13 12:37:44 +0100)

----------------------------------------------------------------
Tiny typo fixes for this second batch for 3.18

----------------------------------------------------------------
Ludovic Desroches (1):
      ARM: at91/dt: sama5d4: use macro instead of numeric value

Peter Rosin (1):
      ARM: at91/dt: Fix sama5d3x typos

 arch/arm/boot/dts/sama5d31.dtsi   | 2 +-
 arch/arm/boot/dts/sama5d33.dtsi   | 2 +-
 arch/arm/boot/dts/sama5d34.dtsi   | 2 +-
 arch/arm/boot/dts/sama5d35.dtsi   | 2 +-
 arch/arm/boot/dts/sama5d36.dtsi   | 2 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi | 2 +-
 arch/arm/boot/dts/sama5d4.dtsi    | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

-- 
Nicolas Ferre
