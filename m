Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaFET2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:28:08 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39839 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbaFET2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:28:04 -0400
X-Sasl-enc: 4YWv1Ni4Rlq4WqvfIM8qe1kvBVYHTPhztbtwrON+cyBF 1401996480
From: Andrew Ruder <andrew.ruder@elecsyscorp.com>
To: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        rdunlap@infradead.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org,
        Andrew Ruder <andrew.ruder@elecsyscorp.com>
Subject: [PATCH 3/6] arm: pxa27x.dtsi: header typo - wrong file
Date: Thu,  5 Jun 2014 14:27:05 -0500
Message-Id: <ceb96637accd7da382ba8bfd0c8327a72cd97ccf.1401995177.git.andrew.ruder@elecsyscorp.com>
X-Mailer: git-send-email 1.9.0.rc3.12.gbc97e2d
In-Reply-To: <cover.1401995177.git.andrew.ruder@elecsyscorp.com>
References: <cover.1401995177.git.andrew.ruder@elecsyscorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing a copy-paste error calling this file the pxa3xx skeleton when it
is actually the pxa27x skeleton.

Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
---
 arch/arm/boot/dts/pxa27x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/pxa27x.dtsi b/arch/arm/boot/dts/pxa27x.dtsi
index a705469..931e1d5 100644
--- a/arch/arm/boot/dts/pxa27x.dtsi
+++ b/arch/arm/boot/dts/pxa27x.dtsi
@@ -1,4 +1,4 @@
-/* The pxa3xx skeleton simply augments the 2xx version */
+/* The pxa27x skeleton simply augments the 2xx version */
 /include/ "pxa2xx.dtsi"
 
 / {
-- 
1.9.0.rc3.12.gbc97e2d

