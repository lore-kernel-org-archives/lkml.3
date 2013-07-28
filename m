Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3G1Xdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 19:33:35 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55416 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3G1Xde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 19:33:34 -0400
MIME-Version: 1.0
Date: Mon, 29 Jul 2013 01:33:33 +0200
Message-ID: <CACRpkdah5T7SZ-JoifP1bzvXn4o7rRbPpss_Rwjevm0H8a7PaA@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for the v3.11 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are some accumulated pin control changes for
the v3.11 series. It's been pretty calm in this tree post
the merge window this time.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.11-2

for you to fetch changes up to db6c2c69c27f2c4fd1e2a1c6b0b1119b1e885f8a:

  pinctrl: fix a memleak when freeing maps (2013-07-25 17:18:36 +0200)

----------------------------------------------------------------
Pin control fixes for the v3.11 series:

- Driver fixes for AM33xx, SIRF and PFC pin controllers.

- Fix a compile warning from the pinctrl single-register
  driver.

- Fix a little nasty memory leak.

----------------------------------------------------------------
Barry Song (1):
      arm/dts: sirf: fix the pingroup name mismatch between drivers and dts

Guennadi Liakhovetski (1):
      pinctrl: sh-pfc: fix SDHI0 VccQ regulator on sh73a0 with DT

Ian Campbell (1):
      pinctrl: am33xx dt binding: correct include path

Jean-Francois Moine (1):
      pinctrl: pinctrl-single: fix compile warning when no CONFIG_PM

Linus Walleij (1):
      pinctrl: fix a memleak when freeing maps

Qipan Li (2):
      pinctrl: sirf: fix the pin number and mux bit for usp0
      pinctrl: sirf: add usp0_uart_nostreamctrl pin group for usp-uart
without flowctrl

 arch/arm/boot/dts/atlas6.dtsi         | 22 ++++++++++++++--------
 arch/arm/boot/dts/prima2.dtsi         | 16 ++++++++--------
 drivers/pinctrl/core.c                |  1 +
 drivers/pinctrl/pinctrl-single.c      |  2 ++
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c   |  1 +
 drivers/pinctrl/sirf/pinctrl-atlas6.c | 24 ++++++++++++++++++++++--
 include/dt-bindings/pinctrl/am33xx.h  |  2 +-
 7 files changed, 49 insertions(+), 19 deletions(-)
