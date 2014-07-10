Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaGJVyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:54:53 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33822 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaGJVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:54:50 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 30/83] hsa/radeon: Fix list of supported devices
Date: Fri, 11 Jul 2014 00:53:46 +0300
Message-Id: <1405029279-6894-2-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index b627e57..a21c095 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -27,7 +27,7 @@
 #include "kfd_priv.h"
 #include "kfd_scheduler.h"
 
-static const struct kfd_device_info bonaire_device_info = {
+static const struct kfd_device_info kaveri_device_info = {
 	.scheduler_class = &radeon_kfd_cik_static_scheduler_class,
 	.max_pasid_bits = 16,
 	.ih_ring_entry_size = 4 * sizeof(uint32_t)
@@ -40,10 +40,28 @@ struct kfd_deviceid {
 
 /* Please keep this sorted by increasing device id. */
 static const struct kfd_deviceid supported_devices[] = {
-	{ 0x1305, &bonaire_device_info },	/* Kaveri */
-	{ 0x1307, &bonaire_device_info },	/* Kaveri */
-	{ 0x130F, &bonaire_device_info },	/* Kaveri */
-	{ 0x665C, &bonaire_device_info },	/* Bonaire */
+	{ 0x1304, &kaveri_device_info },	/* Kaveri */
+	{ 0x1305, &kaveri_device_info },	/* Kaveri */
+	{ 0x1306, &kaveri_device_info },	/* Kaveri */
+	{ 0x1307, &kaveri_device_info },	/* Kaveri */
+	{ 0x1309, &kaveri_device_info },	/* Kaveri */
+	{ 0x130A, &kaveri_device_info },	/* Kaveri */
+	{ 0x130B, &kaveri_device_info },	/* Kaveri */
+	{ 0x130C, &kaveri_device_info },	/* Kaveri */
+	{ 0x130D, &kaveri_device_info },	/* Kaveri */
+	{ 0x130E, &kaveri_device_info },	/* Kaveri */
+	{ 0x130F, &kaveri_device_info },	/* Kaveri */
+	{ 0x1310, &kaveri_device_info },	/* Kaveri */
+	{ 0x1311, &kaveri_device_info },	/* Kaveri */
+	{ 0x1312, &kaveri_device_info },	/* Kaveri */
+	{ 0x1313, &kaveri_device_info },	/* Kaveri */
+	{ 0x1315, &kaveri_device_info },	/* Kaveri */
+	{ 0x1316, &kaveri_device_info },	/* Kaveri */
+	{ 0x1317, &kaveri_device_info },	/* Kaveri */
+	{ 0x1318, &kaveri_device_info },	/* Kaveri */
+	{ 0x131B, &kaveri_device_info },	/* Kaveri */
+	{ 0x131C, &kaveri_device_info },	/* Kaveri */
+	{ 0x131D, &kaveri_device_info },	/* Kaveri */
 };
 
 static const struct kfd_device_info *
-- 
1.9.1

