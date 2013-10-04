Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3JDAas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 20:30:48 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1650 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3JDAap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 20:30:45 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Sherman Yin" <syin@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>
cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        "Sherman Yin" <syin@broadcom.com>
Subject: [PATCH 0/4] Add Broadcom Capri pinctrl driver
Date: Thu, 3 Oct 2013 17:23:15 -0700
Message-ID: <1380846199-12829-1-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-WSS-ID: 7E50D3AD2L891410616-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches adds a pinctrl driver for Broadcom Capri (BCM281xx) SoCs.
The first patch, adding the void * to pinctrl_pin_desc, has been previously
discussed with LinusW.  See this thread:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-April/165880.html

Sherman Yin (4):
  pinctrl: Add void * to pinctrl_pin_desc
  pinctrl: Add pinctrl binding for Broadcom Capri SoCs
  ARM: pinctrl: Add Broadcom Capri pinctrl driver
  pinctrl: Enable pinctrl for Broadcom Capri SoCs

 .../bindings/pinctrl/brcm,capri-pinctrl.txt        |  419 +++++
 arch/arm/boot/dts/bcm11351.dtsi                    |    4 +
 arch/arm/mach-bcm/Kconfig                          |    2 +
 drivers/pinctrl/Kconfig                            |   10 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-capri.c                    | 1727 ++++++++++++++++++++
 include/linux/pinctrl/pinctrl.h                    |    2 +
 7 files changed, 2165 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-capri.c

-- 
1.7.9.5


