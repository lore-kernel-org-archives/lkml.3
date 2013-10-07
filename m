Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab3JGTa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:30:29 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4916 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab3JGT3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:29:46 -0400
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
Subject: [PATCH v2 4/4] pinctrl: Enable pinctrl for Broadcom Capri SoCs
Date: Mon, 7 Oct 2013 12:28:28 -0700
Message-ID: <1381174108-25168-5-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381174108-25168-1-git-send-email-syin@broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
 <1381174108-25168-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E4DD4112L892395742-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl for Broadcom Capri (BCM281xx) SoCs.

Signed-off-by: Sherman Yin <syin@broadcom.com>
Reviewed-by: Christian Daudt <bcm@fixthebug.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
v2: Use hyphens instead of underscore in DT property names.
---
 arch/arm/boot/dts/bcm11351.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 05a5aab..f497a40 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -96,4 +96,8 @@
 		status = "disabled";
 	};
 
+	pinctrl@35004800 {
+		compatible = "brcm,capri-pinctrl";
+		reg = <0x35004800 0x430>;
+	};
 };
-- 
1.7.9.5


