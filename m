Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3CONR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:17:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42889 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab3CONRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:17:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 44/50] staging: omap-thermal: document omap_bandgap_build function
Date: Fri, 15 Mar 2013 09:00:32 -0400
Message-ID: <1363352438-15935-45-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document function to build omap_bandgap structure

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 3150ec2..4b631fd 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -875,6 +875,15 @@ static int omap_bandgap_talert_init(struct omap_bandgap *bg_ptr,
 	return 0;
 }
 
+/**
+ * omap_bandgap_build() - parse DT and setup a struct omap_bandgap
+ * @bg_ptr: pointer to struct omap_bandgap
+ * @pdev: pointer to device struct platform_device
+ *
+ * Used to read the device tree properties accordingly to the bandgap
+ * matching version. Based on bandgap version and its capabilities it
+ * will build a struct omap_bandgap out of the required DT entries.
+ */
 static const struct of_device_id of_omap_bandgap_match[];
 static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 {
-- 
1.7.7.1.488.ge8e1c

