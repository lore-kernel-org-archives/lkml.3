Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaKSGz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 01:55:26 -0500
Received: from mout.web.de ([212.227.17.11]:51772 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbaKSGzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 01:55:24 -0500
From: Soeren Moch <smoch@web.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Soeren Moch <smoch@web.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: imx6q-tbs2910: Enable snvs-poweroff
Date: Wed, 19 Nov 2014 07:54:49 +0100
Message-Id: <1416380089-6317-1-git-send-email-smoch@web.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:7wodhH9+LFUxe6lGTNqWWW8pzy4bTZxvtUtQtdQBNEqsXnFhETe
 kWFC+cVwl3J0bbpPT024pxVSG0fMyWFVVveDaY1/wYU8HHCCPqn7i45eJDc+q7QFQxj7h2B
 qWpHFqMeguquely1yQvcKmOMuNeHoq4cbvmCFzWKDJgVLSLt0ozSvNKjpZbRB3iJhqi0EtW
 QpyOX9WwVxNkePxz+f2XQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables snvs-poweroff for TBS2910 boards.

Signed-off-by: Soeren Moch <smoch@web.de>
--
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/imx6q-tbs2910.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-tbs2910.dts b/arch/arm/boot/dts/imx6q-tbs2910.dts
index d2a5743..7e7496c 100644
--- a/arch/arm/boot/dts/imx6q-tbs2910.dts
+++ b/arch/arm/boot/dts/imx6q-tbs2910.dts
@@ -208,6 +208,10 @@
 	status = "okay";
 };
 
+&snvs_poweroff {
+	status = "okay";
+};
+
 &spdif {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_spdif>;
-- 
1.9.1

