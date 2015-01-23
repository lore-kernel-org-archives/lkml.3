Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbbAWPOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:14:16 -0500
Received: from mga14.intel.com ([192.55.52.115]:30550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbbAWPNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:13:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="666508955"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] usb: dwc3: ULPI or UTMI+ select
Date: Fri, 23 Jan 2015 17:12:55 +0200
Message-Id: <1422025978-178336-6-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make selection between ULPI and UTMI+ interfaces possible by
providing definition for the bit in Global USB2 PHY
Configuration Register that controls it.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/dwc3/core.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index be1c20e..9b6f4c7 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -173,6 +173,7 @@
 /* Global USB2 PHY Configuration Register */
 #define DWC3_GUSB2PHYCFG_PHYSOFTRST	(1 << 31)
 #define DWC3_GUSB2PHYCFG_SUSPHY		(1 << 6)
+#define DWC3_GUSB2PHYCFG_ULPI_UTMI	(1 << 4)
 
 /* Global USB2 PHY Vendor Control Register */
 #define DWC3_GUSB2PHYACC_NEWREGREQ	(1 << 25)
-- 
2.1.4

