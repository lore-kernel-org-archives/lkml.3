Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3CONPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:15:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50627 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab3CONPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:15:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 38/50] staging: omap-thermal: document omap_bandgap_force_single_read
Date: Fri, 15 Mar 2013 09:00:26 -0400
Message-ID: <1363352438-15935-39-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document function to initialize the conversion state machine.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index d893931..065f371 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -705,6 +705,14 @@ void *omap_bandgap_get_sensor_data(struct omap_bandgap *bg_ptr, int id)
 
 /***   Helper functions used during device initialization   ***/
 
+/**
+ * omap_bandgap_force_single_read() - executes 1 single ADC conversion
+ * @bg_ptr: pointer to struct omap_bandgap
+ * @id: sensor id which it is desired to read 1 temperature
+ *
+ * Used to initialize the conversion state machine and set it to a valid
+ * state. Called during device initialization and context restore events.
+ */
 static int
 omap_bandgap_force_single_read(struct omap_bandgap *bg_ptr, int id)
 {
-- 
1.7.7.1.488.ge8e1c

