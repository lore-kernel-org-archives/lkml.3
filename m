Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbbANIlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:41:25 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42922 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbbANIlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:41:24 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: arm@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3 4/4] ARM: devicetree: document supported Conexant Digicolor SoC
Date: Wed, 14 Jan 2015 10:40:33 +0200
Message-Id: <8ac384f1c15c05229d5534036a9a4000d908c0cf.1421219953.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1421219953.git.baruch@tkos.co.il>
References: <cover.1421219953.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of the Digicolor SoCs series only CX92755 is currently supported.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Documentation/devicetree/bindings/arm/digicolor.txt | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/digicolor.txt

diff --git a/Documentation/devicetree/bindings/arm/digicolor.txt b/Documentation/devicetree/bindings/arm/digicolor.txt
new file mode 100644
index 000000000000..658553f40b23
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/digicolor.txt
@@ -0,0 +1,6 @@
+Conexant Digicolor Platforms Device Tree Bindings
+
+Each device tree must specify which Conexant Digicolor SoC it uses.
+Must be the following compatible string:
+
+  cnxt,cx92755
-- 
2.1.4

