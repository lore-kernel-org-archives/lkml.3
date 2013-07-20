Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3GTMWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:22:48 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62918 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3GTMWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:22:45 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.org>,
        devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org
Subject: [PATCH 2/3] MAINTAINERS: Change device tree mailing list
Date: Fri, 19 Jul 2013 20:19:47 -0700
Message-Id: <1374290388-19308-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New list on vger.kernel.org. The old list was a pain to moderate.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: devicetree@vger.kernel.org
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 844d7e8..bc286e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5882,7 +5882,7 @@ OMAP DEVICE TREE SUPPORT
 M:	Benoît Cousson <b-cousson@ti.com>
 M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
-L:	devicetree-discuss@lists.ozlabs.org (moderated for non-subscribers)
+L:	devicetree@vger.kernel.org
 S:	Maintained
 F:	arch/arm/boot/dts/*omap*
 F:	arch/arm/boot/dts/*am3*
@@ -6046,7 +6046,7 @@ F:	drivers/i2c/busses/i2c-ocores.c
 OPEN FIRMWARE AND FLATTENED DEVICE TREE
 M:	Grant Likely <grant.likely@linaro.org>
 M:	Rob Herring <rob.herring@calxeda.com>
-L:	devicetree-discuss@lists.ozlabs.org (moderated for non-subscribers)
+L:	devicetree@vger.kernel.org
 W:	http://fdt.secretlab.ca
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
-- 
1.8.1.2

