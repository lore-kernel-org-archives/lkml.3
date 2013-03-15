Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3CONOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:14:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50596 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab3CONOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:14:21 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 36/50] staging: omap-thermal: rename enable_continuous_mode
Date: Fri, 15 Mar 2013 09:00:24 -0400
Message-ID: <1363352438-15935-37-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch names 'enable_continuous_mode' accordingly to the file
standard naming.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 8746187..e325269 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -735,7 +735,7 @@ omap_bandgap_force_single_read(struct omap_bandgap *bg_ptr, int id)
  *
  * Call this function only if HAS(MODE_CONFIG) is set
  */
-static int enable_continuous_mode(struct omap_bandgap *bg_ptr)
+static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bg_ptr)
 {
 	int i;
 
@@ -973,7 +973,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	}
 
 	if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG))
-		enable_continuous_mode(bg_ptr);
+		omap_bandgap_set_continuous_mode(bg_ptr);
 
 	/* Set .250 seconds time as default counter */
 	if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
-- 
1.7.7.1.488.ge8e1c

