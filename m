Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaK0Xoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:44:34 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:37840 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaK0Xoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:44:32 -0500
X-IronPort-AV: E=Sophos;i="5.07,472,1413270000"; 
   d="scan'208";a="51796596"
From: Ray Jui <rjui@broadcom.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Scott Branden <sbranden@broadcom.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH 0/4] Add pinctrl support to Broadcom Cygnus SoC
Date: Thu, 27 Nov 2014 15:46:26 -0800
Message-ID: <1417131990-17954-1-git-send-email-rjui@broadcom.com>
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

