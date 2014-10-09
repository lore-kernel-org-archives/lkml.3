Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaJIWp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:45:28 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22212 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaJIWpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:45:23 -0400
X-IronPort-AV: E=Sophos;i="5.04,688,1406617200"; 
   d="scan'208";a="47859903"
From: Scott Branden <sbranden@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
CC: JD Zheng <jdzheng@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Scott Branden <sbranden@broadcom.com>
Subject: [PATCH V4 6/7] MAINTAINERS: Entry for Cygnus/iproc arm architecture and clock drivers
Date: Thu, 9 Oct 2014 15:44:30 -0700
Message-ID: <1412894671-5921-7-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412894671-5921-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1412894671-5921-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jonathan Richardson <jonathar@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 MAINTAINERS |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a12edf2..0900082 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2071,9 +2071,24 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2i/
 
-BROADCOM KONA GPIO DRIVER
+BROADCOM CYGNUS/IPROC ARM ARCHITECTURE
 M:	Ray Jui <rjui@broadcom.com>
+M:	Scott Branden <sbranden@broadcom.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	bcm-kernel-feedback-list@broadcom.com
+S:	Maintained
+F:	Documentation/devicetree/bindings/arm/bcm/cygnus.txt
+F:	arch/arm/boot/dts/bcm-cygnus.dtsi
+F:	arch/arm/boot/dts/bcm911360_entphn.dts
+F:	arch/arm/configs/bcm_cygnus_defconfig
+F:	arch/arm/mach-bcm/bcm_cygnus.c
+F:	Documentation/devicetree/bindings/clock/clk-cygnus.txt
+F:	Documentation/devicetree/bindings/clock/clk-iproc.txt
+F:	drivers/clk/bcm/clk-cygnus.c
+F:	drivers/clk/bcm/clk-iproc.c
+
+BROADCOM KONA GPIO DRIVER
+M:	Ray Jui <rjui@broadcom.com>
 S:	Supported
 F:	drivers/gpio/gpio-bcm-kona.c
 F:	Documentation/devicetree/bindings/gpio/gpio-bcm-kona.txt
-- 
1.7.9.5

