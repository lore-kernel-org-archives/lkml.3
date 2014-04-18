Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaDRWDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:03:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:33636 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaDRWDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:03:02 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [GIT PULL] at91: DT for 3.16 #1
Date: Sat, 19 Apr 2014 00:02:59 +0200
Message-ID: <1397858579-11619-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Here is the first AT91 DT pull-request for 3.16. Nice enhancements for
three different products.

Thanks, best regards,

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt

for you to fetch changes up to 27a96a0364787d2b41d2a72d08143d95263e1b07:

  ARM: at91: sama5d3: clock for ssc from rk pin (2014-04-18 22:43:44 +0200)

----------------------------------------------------------------
3.16: first DT series:
- more support for at91sam9rl and its associated EK board
- some improvements to at91sam9g45 (ADC, TS, PWM leds)
- addition of some missing pieces for describing audio
  of SAMA5D3-EK in DT

----------------------------------------------------------------
Alexandre Belloni (5):
      ARM: at91/dt: sam9rl: add lcd, adc, usb gadget and pwm support
      ARM: at91/dt: add peripherals to the at91sam9rlek board
      ARM: at91/dt: sam9g45: improve ADC/touchscreen support
      ARM: at91/dt: at91sam9m10g45ek: add ADC and touchscreen support
      ARM: at91/dt: at91sam9m10g45ek PWM leds polarity is inversed

Bo Shen (5):
      ARM: at91: sama5d3: add DMA property for SSC devices
      ARM: at91: sama5d3: disable sound by default
      ARM: at91: sama5d3: correct the sound compatible string
      ARM: at91: sama5d3: add the missing property
      ARM: at91: sama5d3: clock for ssc from rk pin

 arch/arm/boot/dts/at91sam9g45.dtsi     |  33 +++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts |  20 ++-
 arch/arm/boot/dts/at91sam9rl.dtsi      | 265 +++++++++++++++++++++++++++++++--
 arch/arm/boot/dts/at91sam9rlek.dts     |  90 ++++++++++-
 arch/arm/boot/dts/sama5d3.dtsi         |   6 +
 arch/arm/boot/dts/sama5d3xmb.dtsi      |   9 +-
 6 files changed, 405 insertions(+), 18 deletions(-)

-- 
Nicolas Ferre
