Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaDUFcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:32:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44400 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaDUFba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:31:30 -0400
From: Andy Gross <agross@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 1/4] soc: Placeholder files for drivers/soc
Date: Mon, 21 Apr 2014 00:30:41 -0500
Message-Id: <1398058244-14099-2-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add placeholder Kconfig and linkage for driver/soc.

The first patch set that implemented this was authored by Santosh Shilimkar:
https://lkml.org/lkml/2014/2/28/567

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/Kconfig     |    2 ++
 drivers/Makefile    |    4 ++++
 drivers/soc/Kconfig |    4 ++++
 3 files changed, 10 insertions(+)
 create mode 100644 drivers/soc/Kconfig

diff --git a/drivers/Kconfig b/drivers/Kconfig
index b3138fb..37f955f 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -130,6 +130,8 @@ source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
 
+source "drivers/soc/Kconfig"
+
 source "drivers/clk/Kconfig"
 
 source "drivers/hwspinlock/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 8e3b8b0..ba77e7b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -132,6 +132,10 @@ obj-$(CONFIG_VHOST_RING)	+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
+
+# soc specific drivers
+obj-y				+= soc/
+
 #common clk code
 obj-y				+= clk/
 
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
new file mode 100644
index 0000000..58bd962
--- /dev/null
+++ b/drivers/soc/Kconfig
@@ -0,0 +1,4 @@
+menu "SOC specific Drivers"
+
+endmenu
+`
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

