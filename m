Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477AbaDBWmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:42:39 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15642 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbaDBWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:42:32 -0400
X-IronPort-AV: E=Sophos;i="4.97,783,1389772800"; 
   d="scan'208";a="22565266"
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
Subject: [PATCH v3 3/3] pinctrl: fix typo in bindings documentation
Date: Wed, 2 Apr 2014 15:40:39 -0700
Message-ID: <1396478439-16586-4-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396478439-16586-1-git-send-email-syin@broadcom.com>
References: <1390509887-19278-1-git-send-email-syin@broadcom.com>
 <1396478439-16586-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the missing comma in DT node example.

Signed-off-by: Sherman Yin <syin@broadcom.com>
---
 .../bindings/pinctrl/brcm,bcm11351-pinctrl.txt     |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
index c119deb..67a5db9 100644
--- a/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
@@ -119,7 +119,7 @@ Optional Properties (for HDMI pins):
 Example:
 // pin controller node
 pinctrl@35004800 {
-	compatible = "brcmbcm11351-pinctrl";
+	compatible = "brcm,bcm11351-pinctrl";
 	reg = <0x35004800 0x430>;
 
 	// pin configuration node
-- 
1.7.9.5

