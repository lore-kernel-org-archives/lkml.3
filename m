Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3CONTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:19:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42979 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab3CONTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:19:35 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 50/50] staging: omap-thermal: add documentation for omap_bandgap_validate
Date: Fri, 15 Mar 2013 09:00:38 -0400
Message-ID: <1363352438-15935-51-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the helper to validate a struct omap_bandgap and a sensor id.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 846ced6..33bfe3b 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -437,6 +437,14 @@ exit:
 	return err;
 }
 
+/**
+ * omap_bandgap_validate() - helper to check the sanity of a struct omap_bandgap
+ * @bg_ptr: struct omap_bandgap pointer
+ * @id: bandgap sensor id
+ *
+ * Checks if the bandgap pointer is valid and if the sensor id is also
+ * applicable.
+ */
 static inline int omap_bandgap_validate(struct omap_bandgap *bg_ptr, int id)
 {
 	int ret = 0;
-- 
1.7.7.1.488.ge8e1c

