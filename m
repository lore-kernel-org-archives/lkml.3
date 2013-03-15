Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3CONFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:05:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50221 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3CONFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:05:02 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 10/50] staging: omap-thermal: add documentation for omap_bandgap_power
Date: Fri, 15 Mar 2013 08:59:58 -0400
Message-ID: <1363352438-15935-11-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the helper function to turn a bandgap device on and off.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index ec79ec1..62a5fb9 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -86,6 +86,14 @@ do {								\
 	omap_bandgap_writel(bg_ptr, r, t->reg);			\
 } while (0)
 
+/**
+ * omap_bandgap_power() - controls the power state of a bandgap device
+ * @bg_ptr: pointer to omap_bandgap structure
+ * @on: desired power state (1 - on, 0 - off)
+ *
+ * Used to power on/off a bandgap device instance. Only used on those
+ * that features tempsoff bit.
+ */
 static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
 {
 	int i;
-- 
1.7.7.1.488.ge8e1c

