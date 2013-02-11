Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3BKKao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:30:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:32422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab3BKKaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:30:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,641,1355126400"; 
   d="scan'208";a="285646383"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, srinivas.pandruvada@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/3] HID: sensor-hub: get rid of unused sensor_hub_grabbed_usages[] table
Date: Mon, 11 Feb 2013 12:31:18 +0200
Message-Id: <1360578679-7029-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This table is not used anywhere in the driver so kill it.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/hid/hid-sensor-hub.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index c06e933..2643bce9 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -608,11 +608,6 @@ static const struct hid_device_id sensor_hub_devices[] = {
 };
 MODULE_DEVICE_TABLE(hid, sensor_hub_devices);
 
-static const struct hid_usage_id sensor_hub_grabbed_usages[] = {
-	{ HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
-	{ HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1 }
-};
-
 static struct hid_driver sensor_hub_driver = {
 	.name = "hid-sensor-hub",
 	.id_table = sensor_hub_devices,
-- 
1.7.10.4

