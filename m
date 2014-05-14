Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaENTL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:11:57 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54371 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaENTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:11:30 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: marc.ceeeee@gmail.com, computersforpeace@gmail.com, gregory.0xf0@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Huang Shijie <b32955@freescale.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH 3/3] Documentation: sysfs: add Broadcom GISB arbiter sysfs properties
Date: Wed, 14 May 2014 12:10:49 -0700
Message-Id: <1400094649-11193-5-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400094649-11193-1-git-send-email-f.fainelli@gmail.com>
References: <1400094649-11193-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the sysfs properties exposed by the Broadcom GISB
bus arbiter hardware.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/ABI/testing/sysfs-platform-brcmstb-gisb-arb | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-brcmstb-gisb-arb

diff --git a/Documentation/ABI/testing/sysfs-platform-brcmstb-gisb-arb b/Documentation/ABI/testing/sysfs-platform-brcmstb-gisb-arb
new file mode 100644
index 000000000000..f1bad92bbe27
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-brcmstb-gisb-arb
@@ -0,0 +1,8 @@
+What:		/sys/devices/../../gisb_arb_timeout
+Date:		May 2014
+KernelVersion:	3.17
+Contact:	Florian Fainelli <f.fainelli@gmail.com>
+Description:
+		Returns the currently configured raw timeout value of the
+		Broadcom Set Top Box internal GISB bus arbiter. Minimum value
+		is 1, and maximum value is 0xffffffff.
-- 
1.9.1

