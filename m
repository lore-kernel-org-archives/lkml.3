Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab3CNIoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:44:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:35852 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3CNIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:44:18 -0400
Message-ID: <51418DDC.8030901@atmel.com>
Date: Thu, 14 Mar 2013 09:44:12 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Richard Genoud <richard.genoud@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [GIT PULL] at91: fixes for 3.9-rc #1
References: <51404ABF.7080405@atmel.com>
In-Reply-To: <51404ABF.7080405@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Updated to include Linus' acknowledgement on pinctrl-related patch)

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

for you to fetch changes up to 0ed66befaae893e82c9f016238282d73ef9fd6c7:

  ARM: at91: fix infinite loop in at91_irq_suspend/resume (2013-03-14 09:37:55 +0100)

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
