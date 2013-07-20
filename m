Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3GTMWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:22:18 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59538 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3GTMWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:22:16 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
Date: Fri, 19 Jul 2013 20:19:48 -0700
Message-Id: <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree bindings require a lot more attention than they used to.
We've got a group of volunteers willing to take over maintaining
bindings. This patch adds them to the MAINTAINERS file.

This group still needs to work out a process for maintainership and how
they are going to work together. I recommend that they set up a shared
tree on git.kernel.org that they each have commit access to similar to
the tip tree or the arm-soc tree, but it is up to them.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: devicetree@vger.kernel.org
---
 MAINTAINERS | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bc286e4..12c95d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6050,13 +6050,24 @@ L:	devicetree@vger.kernel.org
 W:	http://fdt.secretlab.ca
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
-F:	Documentation/devicetree
 F:	drivers/of
 F:	include/linux/of*.h
 F:	scripts/dtc
 K:	of_get_property
 K:	of_match_table
 
+OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
+M:	Pawel Moll <pawel.moll@arm.com>
+M:	Mark Rutland <mark.rutland@arm.com>
+M:	Stephen Warren <swarren@wwwdotorg.org>
+M:	Ian Campbell <ian.campbell@citrix.com>
+L:	devicetree@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree
+F:	arch/*/boot/dts
+F:	arch/*/
+F:	include/dt-bindings
+
 OPENRISC ARCHITECTURE
 M:	Jonas Bonn <jonas@southpole.se>
 W:	http://openrisc.net
-- 
1.8.1.2

