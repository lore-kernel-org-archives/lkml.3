Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaJHF1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 01:27:53 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:57249 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbaJHF1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 01:27:49 -0400
X-IronPort-AV: E=Sophos;i="5.04,675,1406617200"; 
   d="scan'208";a="47678160"
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
        <devicetree@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCH 6/6] MAINTAINERS: Entry for Cygnus/iproc arm architecture and clock drivers
Date: Tue, 7 Oct 2014 22:27:05 -0700
Message-ID: <1412746025-11998-7-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412746025-11998-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1412746025-11998-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Richardson <jonathar@broadcom.com>

Acked-by: Jonathan Richardson <jonathar@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 MAINTAINERS |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a12edf2..9024bac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2071,6 +2071,21 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2i/
 
+BROADCOM CYGNUS/IPROC ARM ARCHITECTURE
+M:	Jonathan Richardson <jonathar@broadcom.com>
+M:	Scott Branden <sbranden@broadcom.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	Documentation/devicetree/bindings/arm/cygnus.txt
+F:	arch/arm/boot/dts/bcm-cygnus.dtsi
+F:	arch/arm/boot/dts/bcm911360_entphn.dts
+F:	arch/arm/configs/bcm_cygnus_defconfig
+F:	arch/arm/mach-bcm/board_bcm_cygnus.c
+F:	Documentation/devicetree/bindings/clock/clk-cygnus.txt
+F:	Documentation/devicetree/bindings/clock/clk-iproc.txt
+F:	drivers/clk/bcm/clk-cygnus.c
+F:	drivers/clk/bcm/clk-iproc.c
+
 BROADCOM KONA GPIO DRIVER
 M:	Ray Jui <rjui@broadcom.com>
 L:	bcm-kernel-feedback-list@broadcom.com
-- 
1.7.9.5

