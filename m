Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3CMJpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:45:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:47286 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3CMJpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:45:39 -0400
Message-ID: <51404ABF.7080405@atmel.com>
Date: Wed, 13 Mar 2013 10:45:35 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: fixes for 3.9-rc #1
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Here is a little pull-request for 3.9-rc (I guess it if -rc4 now that
you've just sent the one for -rc3).

I have other material but it is related to the AT91 framebuffer and we are
currently discussing it so I hold them back for now.

Thanks, best regards,

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 5982c177468eb5829146e16b55d43f0b08270ac0:

  ARM: at91: fix infinite loop in at91_irq_suspend/resume (2013-03-13 10:25:38 +0100)

----------------------------------------------------------------
Two patches for Device Tree on at91sam9x5/NAND.
Two more for fixing PM suspend/resume IRQ on AIC5 and
GPIO used with pinctrl.

----------------------------------------------------------------
Ludovic Desroches (2):
      ARM: at91: add gpio suspend/resume support when using pinctrl
      ARM: at91: fix infinite loop in at91_irq_suspend/resume

Richard Genoud (2):
      ARM: at91: dt: at91sam9x5: correct NAND pins comments
      ARM: at91: dt: at91sam9x5: complete NAND pinctrl

 arch/arm/boot/dts/at91sam9x5.dtsi      | 28 ++++++++++++++--
 arch/arm/mach-at91/include/mach/gpio.h |  8 +++++
 arch/arm/mach-at91/irq.c               | 20 +++++-------
 arch/arm/mach-at91/pm.c                | 10 ++++--
 drivers/pinctrl/pinctrl-at91.c         | 61 ++++++++++++++++++++++++++++++++++-
 5 files changed, 110 insertions(+), 17 deletions(-)

-- 
Nicolas Ferre
