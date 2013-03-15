Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3CONLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:11:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42654 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3CONLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:11:52 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 29/50] staging: omap-thermal: document omap_bandgap_add_hyst function
Date: Fri, 15 Mar 2013 09:00:17 -0400
Message-ID: <1363352438-15935-30-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document function to handle hysteresis.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 7b10d18..bff4b75 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -303,6 +303,16 @@ exit:
 	return ret;
 }
 
+/**
+ * omap_bandgap_add_hyst() - add hysteresis (in mCelsius) to an ADC value
+ * @bg_ptr: struct omap_bandgap pointer
+ * @adc_val: temperature value in ADC representation
+ * @hyst_val: hysteresis value in mCelsius
+ * @sum: address where to write the resulting temperature (in ADC scale)
+ *
+ * Adds an hysteresis value (in mCelsius) to a ADC temperature value.
+ * Returns 0 on success, -ERANGE otherwise.
+ */
 static
 int omap_bandgap_add_hyst(struct omap_bandgap *bg_ptr, int adc_val,
 			  int hyst_val, u32 *sum)
-- 
1.7.7.1.488.ge8e1c

