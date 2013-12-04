Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3LDSeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:34:01 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:37654 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756014Ab3LDSd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:33:59 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 1/4] Documentation: add dts binding for X-Gene reboot dts node.
Date: Wed,  4 Dec 2013 10:33:20 -0800
Message-Id: <1386182000-26607-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dts documentation for X-Gene reboot driver.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 .../devicetree/bindings/arm64/xgene/reboot.txt     |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm64/xgene/reboot.txt

diff --git a/Documentation/devicetree/bindings/arm64/xgene/reboot.txt b/Documentation/devicetree/bindings/arm64/xgene/reboot.txt
new file mode 100644
index 0000000..70aabf7
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm64/xgene/reboot.txt
@@ -0,0 +1,11 @@
+Reboot property to control system reboot on storm platforms:
+
+The register attribute contain the address of the reset 
+register.
+
+Example:
+
+	reboot@17000014 {
+		compatible = "apm,xgene-reboot";
+		reg = <0x0 0x17000014 0x0 0x4>;
+	};
-- 
1.7.6.1

