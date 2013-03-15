Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3CONIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:08:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60043 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab3CONIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:08:38 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 20/50] staging: omap-thermal: ADC section
Date: Fri, 15 Mar 2013 09:00:08 -0400
Message-ID: <1363352438-15935-21-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section of ADC helpers functions

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index ded2c8c..2acd30e 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -231,6 +231,8 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+/***   Helper functions which manipulate conversion ADC <-> mi Celsius   ***/
+
 static
 int adc_to_temp_conversion(struct omap_bandgap *bg_ptr, int id, int adc_val,
 			   int *t)
-- 
1.7.7.1.488.ge8e1c

