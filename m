Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3KXGdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 01:33:52 -0500
Received: from gnurou.org ([207.192.72.5]:41189 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab3KXGdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 01:33:43 -0500
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
Subject: [PATCH v11 2/7] of: add vendor prefix for Trusted Logic Mobility
Date: Sun, 24 Nov 2013 15:30:47 +0900
Message-Id: <1385274652-16415-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
References: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "tlm" prefix for Trusted Logic Mobility.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index e306917..5aa905e 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -73,6 +73,7 @@ st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
 ti	Texas Instruments
+tlm	Trusted Logic Mobility
 toshiba	Toshiba Corporation
 toumaz	Toumaz
 v3	V3 Semiconductor
-- 
1.8.4.2

