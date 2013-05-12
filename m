Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3ELOYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:24:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65137 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3ELOYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:24:49 -0400
X-IronPort-AV: E=Sophos;i="4.87,657,1363158000"; 
   d="scan'208";a="46528035"
From: Dolev Raviv <draviv@codeaurora.org>
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org (moderated list:OPEN FIRMWARE
	AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V1 1/8] Documentation: devicetree: Add DT bindings for UFS host controller
Date: Sun, 12 May 2013 17:23:53 +0300
Message-Id: <1368368640-10167-2-git-send-email-draviv@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1368368640-10167-1-git-send-email-draviv@codeaurora.org>
References: <1368368640-10167-1-git-send-email-draviv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compatible list is used in commit 03b1781 but is not documented.
Add necessary device tree bindings to describe on-chip UFS host
controllers.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
new file mode 100644
index 0000000..20468b2
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -0,0 +1,16 @@
+* Universal Flash Storage (UFS) Host Controller
+
+UFSHC nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains "jedec,ufs-1.1"
+- interrupts        : <interrupt mapping for UFS host controller IRQ>
+- reg               : <registers mapping>
+
+Example:
+	ufshc@0xfc598000 {
+		compatible = "jedec,ufs-1.1";
+		reg = <0xfc598000 0x800>;
+		interrupts = <0 28 0>;
+	};
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
