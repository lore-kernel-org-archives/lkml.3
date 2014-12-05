Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaLETs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:48:57 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:18061 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLETsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:48:55 -0500
X-IronPort-AV: E=Sophos;i="5.07,524,1413270000"; 
   d="scan'208";a="52400434"
From: Ray Jui <rjui@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v2 0/4] Add pinctrl support to Broadcom Cygnus SoC
Date: Fri, 5 Dec 2014 11:51:05 -0800
Message-ID: <1417809069-26510-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the initial pinctrl support for the Broadcom Cygnus SoC.
The Cygnus pinctrl controller supports group based alternate function configuration

Changes from v1:
 - Fix a typo in device tree binding document

Ray Jui (4):
  pinctrl: Broadcom Cygnus pinctrl device tree binding
  pinctrl: cygnus: add initial pinctrl support
  ARM: mach-bcm: enable pinctrl support for Cygnus
  ARM: dts: enable pinctrl for Broadcom Cygnus

 .../bindings/pinctrl/brcm,cygnus-pinctrl.txt       |   92 +++
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |    5 +
 arch/arm/mach-bcm/Kconfig                          |    1 +
 drivers/pinctrl/Kconfig                            |    7 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-bcm-cygnus.c               |  753 ++++++++++++++++++++
 6 files changed, 859 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/brcm,cygnus-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-bcm-cygnus.c

-- 
1.7.9.5

