Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab3CZKRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:17:01 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:19004 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3CZKQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:16:57 -0400
Message-ID: <51517592.5010300@atmel.com>
Date: Tue, 26 Mar 2013 11:16:50 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: fixes for 3.9-rc #2
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Another "fixes" pull-request for AT91 on top of material that you have already
taken. Fixes are manly typos but the bad node declaration and some misspelling
can cause confusion.

The following changes since commit 0ed66befaae893e82c9f016238282d73ef9fd6c7:

  ARM: at91: fix infinite loop in at91_irq_suspend/resume (2013-03-14 09:37:55 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 9476a186078f47bdc5f03560074691de98cd767b:

  ARM: at91: Fix typo in restart code panic message (2013-03-26 11:00:02 +0100)

----------------------------------------------------------------
Little fixes mainly related to at91sam9x5 DT.
One typo is the only modification in C code.

----------------------------------------------------------------
Maxime Ripard (1):
      ARM: at91: Fix typo in restart code panic message

Nicolas Ferre (4):
      ARM: at91/dt: fix macb node declaration
      ARM: at91/trivial: typos in compatible property
      ARM: at91/trivial: fix model name for SAM9G15-EK
      ARM: at91: remove partial parameter in bootargs for at91sam9x5ek.dtsi

 arch/arm/boot/dts/at91sam9g15.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9g15ek.dts |  2 +-
 arch/arm/boot/dts/at91sam9g25.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9g25ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9g35.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9g35ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9x25.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9x25ek.dts | 14 ++++++++++++++
 arch/arm/boot/dts/at91sam9x35.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9x35ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi |  7 +------
 arch/arm/mach-at91/setup.c          |  2 +-
 12 files changed, 49 insertions(+), 13 deletions(-)

-- 
Nicolas Ferre
