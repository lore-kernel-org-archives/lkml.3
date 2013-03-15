Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3COKLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:11:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:37959 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3COKLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:11:48 -0400
Message-ID: <5142F3DE.1060209@atmel.com>
Date: Fri, 15 Mar 2013 11:11:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Johan Hovold <jhovold@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: framebuffer enhancements for 3.10
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Following our conversation about these framebuffer patches for
Atmel LCD driver, here are the remaining three patches that can be
pushed for 3.10. As suggested by Arnd, I have kept them on top of last
commit concerning this topic that have already been merged in arm-soc 3.9
fixes branch.
Thanks a lot for taking care of these modifications.

Best regards,

The following changes since commit 67cf9c0a00bd88443adb7d6c3efa8b18d03f97c5:

  ARM: at91: fix LCD-wiring mode (2013-03-13 11:05:04 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-driversLCD

for you to fetch changes up to bbd44f6bd9d1aa735b180b29b5719d63a8e87b55:

  ARM: at91/avr32/atmel_lcdfb: add platform device-id table (2013-03-13 11:05:12 +0100)

----------------------------------------------------------------
Some Atmel framebuffer driver enhancements with modification
of configuration data in ARM/AT91 and AVR32/AP7 trees.
A merge of these modifications seems easier through arm-soc
git tree nowadays.

----------------------------------------------------------------
Johan Hovold (3):
      ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
      atmel_lcdfb: move lcdcon2 register access to compute_hozval
      ARM: at91/avr32/atmel_lcdfb: add platform device-id table

 arch/arm/mach-at91/at91sam9261.c         |   2 +
 arch/arm/mach-at91/at91sam9261_devices.c |   6 +-
 arch/arm/mach-at91/at91sam9263.c         |   1 +
 arch/arm/mach-at91/at91sam9263_devices.c |   2 +-
 arch/arm/mach-at91/at91sam9g45.c         |   2 +
 arch/arm/mach-at91/at91sam9g45_devices.c |   6 +-
 arch/arm/mach-at91/at91sam9rl.c          |   1 +
 arch/arm/mach-at91/at91sam9rl_devices.c  |   2 +-
 arch/avr32/mach-at32ap/at32ap700x.c      |   6 +-
 drivers/video/atmel_lcdfb.c              | 120 +++++++++++++++++++++++++++--------
 include/video/atmel_lcdc.h               |   4 +-
 11 files changed, 117 insertions(+), 35 deletions(-)

-- 
Nicolas Ferre
