Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3ISNQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:16:47 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:44489 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3ISNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:16:45 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH] of: add vendor prefix for PHYTEC Messtechnik GmbH
Date: Thu, 19 Sep 2013 09:16:36 -0400
Message-Id: <1379596596-12375-1-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds PHYTEC to the list of DT vendor prefixes.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 2956800..ddcd322 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -45,6 +45,7 @@ nintendo	Nintendo
 nvidia	NVIDIA
 nxp	NXP Semiconductors
 onnn	ON Semiconductor Corp.
+phytec	PHYTEC Messtechnik GmbH
 picochip	Picochip Ltd
 powervr	PowerVR (deprecated, use img)
 qca	Qualcomm Atheros, Inc.
-- 
1.8.4

