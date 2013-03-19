Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3CSOzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:55:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56656 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab3CSOzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:55:16 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 01/12] staging: omap-thermal: fix return value
Date: Tue, 19 Mar 2013 10:54:17 -0400
Message-ID: <1363704868-11843-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the proper error value in _omap_bandgap_read_threshold.

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 33bfe3b..cb7aa35 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -566,7 +566,7 @@ int _omap_bandgap_read_threshold(struct omap_bandgap *bg_ptr, int id,
 	*val = temp;
 
 exit:
-	return 0;
+	return ret;
 }
 
 /***   Exposed APIs   ***/
-- 
1.7.7.1.488.ge8e1c

