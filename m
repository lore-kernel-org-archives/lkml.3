Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3IXUTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:19:16 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1271 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab3IXUTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:19:15 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Christian Daudt" <csd@broadcom.com>
To: "Russell King" <linux@arm.linux.org.uk>,
        "Christian Daudt" <csd@broadcom.com>
cc: "Matt Porter" <matt.porter@linaro.org>,
        "Alex Elder" <alex.elder@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Christian Daudt" <bcm@fixthebug.org>
Subject: [PATCH] ARM: bcm281xx: more descriptive machine string
Date: Tue, 24 Sep 2013 13:18:59 -0700
Message-ID: <1380053939-11329-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7E5F2EB02L888124827-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SoC model to DT_MACHINE_START string.

Signed-off-by: Christian Daudt <bcm@fixthebug.org>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Mark Hambleton <mahamble@broadcom.com>
Reviewed-by: James King <jamesk@broadcom.com>

diff --git a/arch/arm/mach-bcm/board_bcm281xx.c b/arch/arm/mach-bcm/board_bcm281xx.c
index 8d9f931..dcfaf4a 100644
--- a/arch/arm/mach-bcm/board_bcm281xx.c
+++ b/arch/arm/mach-bcm/board_bcm281xx.c
@@ -67,7 +67,7 @@ static void __init board_init(void)
 
 static const char * const bcm11351_dt_compat[] = { "brcm,bcm11351", NULL, };
 
-DT_MACHINE_START(BCM11351_DT, "Broadcom Application Processor")
+DT_MACHINE_START(BCM11351_DT, "BCM281xx Broadcom Application Processor")
 	.init_time = clocksource_of_init,
 	.init_machine = board_init,
 	.restart = bcm_kona_restart,
-- 
1.7.10.4


