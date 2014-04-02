Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbaDBWmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:42:43 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:57799 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbaDBWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:42:33 -0400
X-IronPort-AV: E=Sophos;i="4.97,783,1389772800"; 
   d="scan'208";a="22903788"
From: Sherman Yin <syin@broadcom.com>
To: Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>, Olof Johansson <olof@lixom.net>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Sherman Yin <syin@broadcom.com>
Subject: [PATCH v3 0/3] pinctrl: Rename Broadcom Capri pinctrl driver
Date: Wed, 2 Apr 2014 15:40:36 -0700
Message-ID: <1396478439-16586-1-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390509887-19278-1-git-send-email-syin@broadcom.com>
References: <1390509887-19278-1-git-send-email-syin@broadcom.com>
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
v3: removed the device tree/compatible string portion of changes which
    were already accepted in 3.14-rc6.  Fixed typo in documentation.
v2: split single patch into 4 patches

Sherman Yin (3):
  pinctrl: Rename Broadcom Capri pinctrl driver
  Update bcm_defconfig with new pinctrl CONFIG
  pinctrl: fix typo in bindings documentation

 .../bindings/pinctrl/brcm,bcm11351-pinctrl.txt     |    2 +-
 arch/arm/configs/bcm_defconfig                     |    2 +-
 drivers/pinctrl/Kconfig                            |    8 +-
 drivers/pinctrl/Makefile                           |    2 +-
 .../{pinctrl-capri.c => pinctrl-bcm281xx.c}        | 1519 ++++++++++----------
 5 files changed, 770 insertions(+), 763 deletions(-)
 rename drivers/pinctrl/{pinctrl-capri.c => pinctrl-bcm281xx.c} (25%)

-- 
1.7.9.5

