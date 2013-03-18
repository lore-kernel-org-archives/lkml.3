Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3CRPA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:00:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56589 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3CRPAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:00:24 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/8] staging: omap-thermal: fix return value
Date: Mon, 18 Mar 2013 10:59:09 -0400
Message-ID: <1363618756-15851-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the proper error value in _omap_bandgap_read_threshold.

Cc: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

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

