Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaIPT44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:56:56 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13109 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbaIPT4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:56:39 -0400
X-IronPort-AV: E=Sophos;i="5.04,535,1406617200"; 
   d="scan'208";a="45743614"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: [PATCH 6/6] MAINTAINERS: Entry for Cygnus/iproc arm architecture and clock drivers
Date: Tue, 16 Sep 2014 12:58:17 -0700
Message-ID: <1410897497-27527-7-git-send-email-jonathar@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410897497-27527-1-git-send-email-jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
 <1410897497-27527-1-git-send-email-jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Jonathan Richardson <jonathar@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
Signed-off-by: Jonathan Richardson <jonathar@broadcom.com>
---
 MAINTAINERS |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 809ecd6..2152ee0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2070,6 +2070,27 @@ L:	linux-scsi@vger.kernel.org
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
+
+BROADCOM CYGNUS/IPROC CLOCK DRIVERS
+M:	Jonathan Richardson <jonathar@broadcom.com>
+M:	Scott Branden <sbranden@broadcom.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
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

