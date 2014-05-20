Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaETNSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:18:35 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:50433 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbaETNS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:18:28 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Olof Johansson <olof@lixom.net>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v7 2/4] ARM: dts: Fix STi boards compatibles
Date: Tue, 20 May 2014 15:17:30 +0200
Message-Id: <1400591852-17577-3-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400591852-17577-1-git-send-email-maxime.coquelin@st.com>
References: <1400591852-17577-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compatible strings have to be ordered from specific to generic.
This patch fixes this for STi boards, which did the exact opposite.

Cc: Olof Johansson <olof@lixom.net>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih415-b2000.dts | 2 +-
 arch/arm/boot/dts/stih415-b2020.dts | 2 +-
 arch/arm/boot/dts/stih416-b2000.dts | 3 +--
 arch/arm/boot/dts/stih416-b2020.dts | 3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/stih415-b2000.dts b/arch/arm/boot/dts/stih415-b2000.dts
index d4af531..bdfbd37 100644
--- a/arch/arm/boot/dts/stih415-b2000.dts
+++ b/arch/arm/boot/dts/stih415-b2000.dts
@@ -11,5 +11,5 @@
 #include "stih41x-b2000.dtsi"
 / {
 	model = "STiH415 B2000 Board";
-	compatible = "st,stih415", "st,stih415-b2000";
+	compatible = "st,stih415-b2000", "st,stih415";
 };
diff --git a/arch/arm/boot/dts/stih415-b2020.dts b/arch/arm/boot/dts/stih415-b2020.dts
index 442b019..71903a8 100644
--- a/arch/arm/boot/dts/stih415-b2020.dts
+++ b/arch/arm/boot/dts/stih415-b2020.dts
@@ -11,5 +11,5 @@
 #include "stih41x-b2020.dtsi"
 / {
 	model = "STiH415 B2020 Board";
-	compatible = "st,stih415", "st,stih415-b2020";
+	compatible = "st,stih415-b2020", "st,stih415";
 };
diff --git a/arch/arm/boot/dts/stih416-b2000.dts b/arch/arm/boot/dts/stih416-b2000.dts
index a5eb6ee..488e80a 100644
--- a/arch/arm/boot/dts/stih416-b2000.dts
+++ b/arch/arm/boot/dts/stih416-b2000.dts
@@ -9,8 +9,7 @@
 /dts-v1/;
 #include "stih416.dtsi"
 #include "stih41x-b2000.dtsi"
-
 / {
-	compatible = "st,stih416", "st,stih416-b2000";
 	model = "STiH416 B2000";
+	compatible = "st,stih416-b2000", "st,stih416";
 };
diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index 276f28d..4e2df66 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -11,6 +11,5 @@
 #include "stih41x-b2020.dtsi"
 / {
 	model = "STiH416 B2020";
-	compatible = "st,stih416", "st,stih416-b2020";
-
+	compatible = "st,stih416-b2020", "st,stih416";
 };
-- 
1.9.1

