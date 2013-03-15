Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3CONMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:12:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60194 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3CONML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:12:11 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 30/50] staging: omap-thermal: threshold manipulation section
Date: Fri, 15 Mar 2013 09:00:18 -0400
Message-ID: <1363352438-15935-31-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section of functions manipulating thresholds for Alert and Shutdown.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index bff4b75..f86c104 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -335,6 +335,8 @@ exit:
 	return ret;
 }
 
+/***   Helper functions handling device Alert/Shutdown signals   ***/
+
 /* Talert masks. Call it only if HAS(TALERT) is set */
 static int temp_sensor_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 					 u32 t_hot, u32 t_cold)
-- 
1.7.7.1.488.ge8e1c

