Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaGVOye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:54:34 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33693 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbaGVOwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:52:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, dbaryshkov@gmail.com,
        Christophe Kerello <christophe.kerello@st.com>
Subject: [PATCH 2/5] power: reset: st: Provide DT bindings for ST's Power Reset driver
Date: Tue, 22 Jul 2014 15:52:29 +0100
Message-Id: <1406040752-25229-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
References: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/power/reset/st-reset.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/reset/st-reset.txt

diff --git a/Documentation/devicetree/bindings/power/reset/st-reset.txt b/Documentation/devicetree/bindings/power/reset/st-reset.txt
new file mode 100644
index 0000000..809af54
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/reset/st-reset.txt
@@ -0,0 +1,11 @@
+*Device-Tree bindings for ST SW reset functionality
+
+Required properties:
+- compatible: should be "st,<chip>-restart".
+- st,syscfg: should be a phandle of the syscfg node.
+
+Example node:
+	restart {
+		compatible = "st,stih416-restart";
+		st,syscfg = <&syscfg_sbc>;
+	};
-- 
1.8.3.2

