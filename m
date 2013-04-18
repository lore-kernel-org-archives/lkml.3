Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936240Ab3DRRUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:20:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45508 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682Ab3DRRUF (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 18 Apr 2013 13:20:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] MAINTAINERS: Add git repository and update my address
Date: Thu, 18 Apr 2013 18:20:01 +0100
Message-Id: <1366305601-21112-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a3be666..0c9c104 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7431,9 +7431,10 @@ S:	Maintained
 F:	drivers/clk/spear/
 
 SPI SUBSYSTEM
-M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
+M:	Mark Brown <broonie@kernel.org>
 M:	Grant Likely <grant.likely@linaro.org>
 L:	spi-devel-general@lists.sourceforge.net
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
 Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
 S:	Maintained
 F:	Documentation/spi/
-- 
1.7.10.4

