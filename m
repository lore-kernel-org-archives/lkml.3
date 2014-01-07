Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaAGWwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 17:52:07 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:45735 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754168AbaAGWvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 17:51:15 -0500
From: Feng Kan <fkan@apm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot dts node.
Date: Tue,  7 Jan 2014 14:50:36 -0800
Message-Id: <1389135041-16062-2-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1389135041-16062-1-git-send-email-fkan@apm.com>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add X-Gene reboot device tree node documentation.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 .../devicetree/bindings/arm64/xgene/reboot.txt     |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm64/xgene/reboot.txt

diff --git a/Documentation/devicetree/bindings/arm64/xgene/reboot.txt b/Documentation/devicetree/bindings/arm64/xgene/reboot.txt
new file mode 100644
index 0000000..51d23c1
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm64/xgene/reboot.txt
@@ -0,0 +1,10 @@
+Reboot property to control system reboot on storm platforms:
+
+The register attribute contain the address of the reset register.
+
+Example:
+
+	reboot@0 {
+		compatible = "apm,xgene-reboot";
+		reg = <0x0 0x17000014 0x0 0x4>;
+	};
-- 
1.7.6.1

