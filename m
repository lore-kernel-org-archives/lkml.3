Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3JQMJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:09:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53983 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3JQMJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:09:27 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [RESEND][PATCH] of: add vendor prefix for PHYTEC Messtechnik GmbH
Date: Thu, 17 Oct 2013 08:09:16 -0400
Message-Id: <1382011756-24884-1-git-send-email-matt.porter@linaro.org>
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

