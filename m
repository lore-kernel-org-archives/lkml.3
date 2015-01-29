Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbbA2Ksp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:48:45 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:59865 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbA2Ksi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:48:38 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <wim@iguana.be>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>,
        <paul@crapouillou.net>
Subject: [PATCH_V2 1/2] dt: watchdog: Add DT binding documentation for jz4740 watchdog timer
Date: Thu, 29 Jan 2015 10:48:25 +0000
Message-ID: <1422528506-39954-2-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422528506-39954-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422528506-39954-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding for jz4740 watchdog timer. It is a simple watchdog timer.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

---
The jz4740 is platform only at the moment.

But DT support is being added

See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

V2 Changes

Removed clock binding because of pending work in clock tree. Will add
binding later. Rather than introduce a bad binding now and change later.

Renamed to jz4740 instead of jz47xx.
---
 .../devicetree/bindings/watchdog/ingenic,jz4740-wdt.txt      | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/ingenic,jz4740-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/ingenic,jz4740-wdt.txt b/Documentation/devicetree/bindings/watchdog/ingenic,jz4740-wdt.txt
new file mode 100644
index 0000000..e27763e
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/ingenic,jz4740-wdt.txt
@@ -0,0 +1,12 @@
+Ingenic Watchdog Timer (WDT) Controller for JZ4740
+
+Required properties:
+compatible: "ingenic,jz4740-watchdog"
+reg: Register address and length for watchdog registers
+
+Example:
+
+watchdog: jz4740-watchdog@0x10002000 {
+	compatible = "ingenic,jz4740-watchdog";
+	reg = <0x10002000 0x100>;
+};
-- 
1.9.1

