Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaIBPnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:43:45 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39219 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbaIBPnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:43:08 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        iivanov@mm-sol.com, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v2 2/3] ARM: dts: qcom: Enable serial port on IFC6540 boards
Date: Tue,  2 Sep 2014 18:40:42 +0300
Message-Id: <1409672443-4289-3-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the serial port on the IFC6540 boards.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
index 4603e91..e41cb8a 100644
--- a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
+++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
@@ -3,4 +3,10 @@
 / {
 	model = "Qualcomm APQ8084/IFC6540";
 	compatible = "qcom,apq8084-ifc6540", "qcom,apq8084";
+
+	soc {
+		serial@f995e000 {
+			status = "okay";
+		};
+	};
 };
-- 
1.7.9.5

