Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3KXGdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 01:33:50 -0500
Received: from gnurou.org ([207.192.72.5]:41207 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab3KXGds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 01:33:48 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>,
        Dave Martin <Dave.Martin@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v11 3/7] of: add Trusted Foundations bindings documentation
Date: Sun, 24 Nov 2013 15:30:48 +0900
Message-Id: <1385274652-16415-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
References: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Device Tree bindings documentation for the Trusted Foundation
secure monitor.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../arm/firmware/tlm,trusted-foundations.txt         | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tlm,trusted-foundations.txt

diff --git a/Documentation/devicetree/bindings/arm/firmware/tlm,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tlm,trusted-foundations.txt
new file mode 100644
index 0000000..780d039
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/firmware/tlm,trusted-foundations.txt
@@ -0,0 +1,20 @@
+Trusted Foundations
+-------------------
+
+Boards that use the Trusted Foundations secure monitor can signal its
+presence by declaring a node compatible with "tlm,trusted-foundations"
+under the /firmware/ node
+
+Required properties:
+- compatible: "tlm,trusted-foundations"
+- tlm,version-major: major version number of Trusted Foundations firmware
+- tlm,version-minor: minor version number of Trusted Foundations firmware
+
+Example:
+	firmware {
+		trusted-foundations {
+			compatible = "tlm,trusted-foundations";
+			tlm,version-major = <2>;
+			tlm,version-minor = <8>;
+		};
+	};
-- 
1.8.4.2

