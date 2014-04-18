Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaDRQpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:45:31 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:30042 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaDRQpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:45:18 -0400
X-IronPort-AV: E=Sophos;i="4.97,885,1389772800"; 
   d="scan'208";a="25487185"
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>,
        Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        Christian Daudt <bcm@fixthebug.org>,
        "Grant Likely" <grant.likely@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v6 4/5] ARM: dts: Enable the PWM for bcm28155 AP board
Date: Fri, 18 Apr 2014 09:44:53 -0700
Message-ID: <1397839494-21049-5-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397839494-21049-1-git-send-email-tim.kryger@linaro.org>
References: <1397839494-21049-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the PWM as enabled on the bcm28155 AP board.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/boot/dts/bcm28155-ap.dts |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index af3da55..9ce91dd 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -69,6 +69,10 @@
 		status = "okay";
 	};
 
+	pwm: pwm@3e01a000 {
+		status = "okay";
+	};
+
 	usbotg: usb@3f120000 {
 		vusb_d-supply = <&usbldo_reg>;
 		vusb_a-supply = <&iosr1_reg>;
-- 
1.7.9.5

