Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaAWUqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:46:43 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:37753 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaAWUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:45:43 -0500
X-IronPort-AV: E=Sophos;i="4.95,708,1384329600"; 
   d="scan'208";a="10928267"
From: Sherman Yin <syin@broadcom.com>
To: Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Sherman Yin <syin@broadcom.com>
Subject: [PATCH v2 0/4] pinctrl: Rename Broadcom Capri pinctrl driver
Date: Thu, 23 Jan 2014 12:44:43 -0800
Message-ID: <1390509887-19278-1-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390343886-25852-1-git-send-email-syin@broadcom.com>
References: <1390343886-25852-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be consistent with other Broadcom drivers, the Broadcom Capri pinctrl
driver and its related CONFIG option are renamed to bcm281xx.

Devicetree compatible string and binding documentation use
"brcm,bcm11351-pinctrl" to match the machine binding here:
Documentation/devicetree/bindings/arm/bcm/bcm11351.txt

This driver supports pinctrl on BCM11130, BCM11140, BCM11351, BCM28145
and BCM28155 SoCs.

Signed-off-by: Sherman Yin <syin@broadcom.com>
Reviewed-by: Matt Porter <mporter@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
v2: split single patch into 4 patches

Sherman Yin (4):
  pinctrl: Rename Broadcom Capri pinctrl binding
  pinctrl: Rename Broadcom Capri pinctrl driver
  Update bcm_defconfig with new pinctrl CONFIG
  Update dtsi with new pinctrl compatible string

 ...capri-pinctrl.txt => brcm,bcm11351-pinctrl.txt} |    8 +-
 arch/arm/boot/dts/bcm11351.dtsi                    |    2 +-
 arch/arm/configs/bcm_defconfig                     |    2 +-
 drivers/pinctrl/Kconfig                            |    8 +-
 drivers/pinctrl/Makefile                           |    2 +-
 .../{pinctrl-capri.c => pinctrl-bcm281xx.c}        | 1521 ++++++++++----------
 6 files changed, 775 insertions(+), 768 deletions(-)
 rename Documentation/devicetree/bindings/pinctrl/{brcm,capri-pinctrl.txt => brcm,bcm11351-pinctrl.txt} (98%)
 rename drivers/pinctrl/{pinctrl-capri.c => pinctrl-bcm281xx.c} (25%)

-- 
1.7.9.5

