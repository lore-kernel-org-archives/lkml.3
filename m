Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3ILLY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:24:29 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9240 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3ILLXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:23:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Sep 2013 04:20:36 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <broonie@kernel.org>,
        <swarren@wwwdotorg.org>
CC: <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v4 2/3] of: add vendor prefix for GMT
Date: Thu, 12 Sep 2013 19:24:20 +0800
Message-ID: <1378985061-28547-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378985061-28547-1-git-send-email-wni@nvidia.com>
References: <1378985061-28547-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Global Mixed-mode Technology Inc. to the list
of devicetree vendor prefixes.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 2956800..634c35f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -28,6 +28,7 @@ est	ESTeem Wireless Modems
 fsl	Freescale Semiconductor
 GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
+gmt	Global Mixed-mode Technology Inc.
 hisilicon	Hisilicon Limited.
 hp	Hewlett Packard
 ibm	International Business Machines (IBM)
-- 
1.7.9.5

