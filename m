Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946072Ab3FUVHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:07:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53612 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946016Ab3FUVHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:07:37 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] thermal: MAINTAINERS: Add git tree path for SoC specific updates
Date: Fri, 21 Jun 2013 17:07:10 -0400
Message-ID: <1371848830-5261-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To reduce thermal maintenance load on Rui, SoC specific patches would be
applied by me now. Rui Zhang will pull in these changes from time to time (at
rc's). Additionally I would be sending him pull request for every merge
window and rc's (for fixes).

Branch names would be: next and fixes.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..48ff6282 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8032,6 +8032,7 @@ M:      Zhang Rui <rui.zhang@intel.com>
 M:      Eduardo Valentin <eduardo.valentin@ti.com>
 L:      linux-pm@vger.kernel.org
 T:      git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
+T:      git git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
 Q:      https://patchwork.kernel.org/project/linux-pm/list/
 S:      Supported
 F:      drivers/thermal/
-- 
1.8.2.1.342.gfa7285d

