Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaBLRUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:20:16 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37886 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaBLRUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:20:14 -0500
MIME-Version: 1.0
Date: Wed, 12 Feb 2014 09:20:13 -0800
Message-ID: <CAEPRUYpCVpV7HwuO6c95ybk3yp1teJgW-9qwyHnjKbs03C9bgQ@mail.gmail.com>
Subject: [GIT PULL] bcm pinctrl rename
From: Christian Daudt <bcm@fixthebug.org>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, Matt Porter <mporter@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sherman Yin <syin@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://github.com/broadcom/bcm11351.git tags/bcm-for-3.14-pinctrl-rename

for you to fetch changes up to f5310a1712b68c7f83539fce6ebbfb6f0f510f5b:

  Update dtsi with new pinctrl compatible string (2014-02-12 09:06:53 -0800)

----------------------------------------------------------------
Renaming pinctrl code to keep in line with rest of bcm mobile

Given that this driver has been in the works for a while, it
was written prior to the code standardizing on bcm-based naming.
this patchset brings it in line with the remainder of the code.

----------------------------------------------------------------
Sherman Yin (4):
      pinctrl: Rename Broadcom Capri pinctrl binding
      pinctrl: Rename Broadcom Capri pinctrl driver
      Update bcm_defconfig with new pinctrl CONFIG
      Update dtsi with new pinctrl compatible string

 .../bindings/pinctrl/{brcm,capri-pinctrl.txt =>
brcm,bcm11351-pinctrl.txt}        |    8 +-
 arch/arm/boot/dts/bcm11351.dtsi
            |    2 +-
 arch/arm/configs/bcm_defconfig
            |    2 +-
 drivers/pinctrl/Kconfig
            |    8 +-
 drivers/pinctrl/Makefile
            |    2 +-
 drivers/pinctrl/pinctrl-bcm281xx.c
            | 1461 ++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-capri.c
            | 1454 -------------------------------------
 7 files changed, 1472 insertions(+), 1465 deletions(-)
 rename Documentation/devicetree/bindings/pinctrl/{brcm,capri-pinctrl.txt
=> brcm,bcm11351-pinctrl.txt} (98%)
 create mode 100644 drivers/pinctrl/pinctrl-bcm281xx.c
 delete mode 100644 drivers/pinctrl/pinctrl-capri.c
