Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3CONNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:13:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42738 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab3CONNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:13:39 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 34/50] staging: omap-thermal: device initialization section
Date: Fri, 15 Mar 2013 09:00:22 -0400
Message-ID: <1363352438-15935-35-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section of helper functions to initilize the bandgap device

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 2a13bf0..8c7ac0e 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -703,6 +703,8 @@ void *omap_bandgap_get_sensor_data(struct omap_bandgap *bg_ptr, int id)
 	return bg_ptr->conf->sensors[id].data;
 }
 
+/***   Helper functions used during device initialization   ***/
+
 static int
 omap_bandgap_force_single_read(struct omap_bandgap *bg_ptr, int id)
 {
-- 
1.7.7.1.488.ge8e1c

