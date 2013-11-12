Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab3KLTw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:52:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55682 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310Ab3KLTvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:51:24 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>
CC: <wni@nvidia.com>, <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCHv5 20/20] MAINTAINERS: add maintainer entry for thermal bindings
Date: Tue, 12 Nov 2013 15:46:22 -0400
Message-ID: <1384285582-16933-21-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discussion and agreement of thermal device tree bindings,
it is desirable to properly maintain thermal bindings for
existing and upcoming devices.

As original author of thermal device tree bindings, I am
volunteering to maintain them.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3438384..94bfc46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6178,6 +6178,7 @@ M:	Pawel Moll <pawel.moll@arm.com>
 M:	Mark Rutland <mark.rutland@arm.com>
 M:	Stephen Warren <swarren@wwwdotorg.org>
 M:	Ian Campbell <ijc+devicetree@hellion.org.uk>
+M:	Eduardo Valentin <eduardo.valentin@ti.com>
 L:	devicetree@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/
-- 
1.8.2.1.342.gfa7285d

