Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3IRSuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:50:05 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55134 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3IRStI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:49:08 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 1/4] clockchips: Add FEAT_PERCPU clockevent flag
Date: Wed, 18 Sep 2013 11:48:35 -0700
Message-Id: <1379530118-22813-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the flag CLOCK_EVT_FEAT_PERCPU which is supposed to be set for per
cpu clockevent devices.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 include/linux/clockchips.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 0857922..493aa02 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -60,6 +60,7 @@ enum clock_event_mode {
  * Core shall set the interrupt affinity dynamically in broadcast mode
  */
 #define CLOCK_EVT_FEAT_DYNIRQ		0x000020
+#define CLOCK_EVT_FEAT_PERCPU		0x000040
 
 /**
  * struct clock_event_device - clock event device descriptor
-- 
1.8.4

