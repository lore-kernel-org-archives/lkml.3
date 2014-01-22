Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaAVNMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:12:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37286 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496AbaAVNMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:12:44 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: wm5102: Make additional DSP registers available to the user
Date: Wed, 22 Jan 2014 13:04:23 +0000
Message-Id: <1390395865-4396-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose some DSP registers which are useful for DSP users to be able to
access whilst debugging their firmware.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c           |   34 +++++++++++++++++++++++++++++++++
 include/linux/mfd/arizona/registers.h |   17 ++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 1e9a4b2..bf17bff 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1852,6 +1852,23 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_WDMA_BUFFER_1:
+	case ARIZONA_DSP1_WDMA_BUFFER_2:
+	case ARIZONA_DSP1_WDMA_BUFFER_3:
+	case ARIZONA_DSP1_WDMA_BUFFER_4:
+	case ARIZONA_DSP1_WDMA_BUFFER_5:
+	case ARIZONA_DSP1_WDMA_BUFFER_6:
+	case ARIZONA_DSP1_WDMA_BUFFER_7:
+	case ARIZONA_DSP1_WDMA_BUFFER_8:
+	case ARIZONA_DSP1_RDMA_BUFFER_1:
+	case ARIZONA_DSP1_RDMA_BUFFER_2:
+	case ARIZONA_DSP1_RDMA_BUFFER_3:
+	case ARIZONA_DSP1_RDMA_BUFFER_4:
+	case ARIZONA_DSP1_RDMA_BUFFER_5:
+	case ARIZONA_DSP1_RDMA_BUFFER_6:
+	case ARIZONA_DSP1_WDMA_CONFIG_1:
+	case ARIZONA_DSP1_WDMA_CONFIG_2:
+	case ARIZONA_DSP1_RDMA_CONFIG_1:
 	case ARIZONA_DSP1_SCRATCH_0:
 	case ARIZONA_DSP1_SCRATCH_1:
 	case ARIZONA_DSP1_SCRATCH_2:
@@ -1910,6 +1927,23 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_WDMA_BUFFER_1:
+	case ARIZONA_DSP1_WDMA_BUFFER_2:
+	case ARIZONA_DSP1_WDMA_BUFFER_3:
+	case ARIZONA_DSP1_WDMA_BUFFER_4:
+	case ARIZONA_DSP1_WDMA_BUFFER_5:
+	case ARIZONA_DSP1_WDMA_BUFFER_6:
+	case ARIZONA_DSP1_WDMA_BUFFER_7:
+	case ARIZONA_DSP1_WDMA_BUFFER_8:
+	case ARIZONA_DSP1_RDMA_BUFFER_1:
+	case ARIZONA_DSP1_RDMA_BUFFER_2:
+	case ARIZONA_DSP1_RDMA_BUFFER_3:
+	case ARIZONA_DSP1_RDMA_BUFFER_4:
+	case ARIZONA_DSP1_RDMA_BUFFER_5:
+	case ARIZONA_DSP1_RDMA_BUFFER_6:
+	case ARIZONA_DSP1_WDMA_CONFIG_1:
+	case ARIZONA_DSP1_WDMA_CONFIG_2:
+	case ARIZONA_DSP1_RDMA_CONFIG_1:
 	case ARIZONA_DSP1_SCRATCH_0:
 	case ARIZONA_DSP1_SCRATCH_1:
 	case ARIZONA_DSP1_SCRATCH_2:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index b40960d..ea45877 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -999,6 +999,23 @@
 #define ARIZONA_DSP1_STATUS_1                    0x1104
 #define ARIZONA_DSP1_STATUS_2                    0x1105
 #define ARIZONA_DSP1_STATUS_3                    0x1106
+#define ARIZONA_DSP1_WDMA_BUFFER_1               0x1110
+#define ARIZONA_DSP1_WDMA_BUFFER_2               0x1111
+#define ARIZONA_DSP1_WDMA_BUFFER_3               0x1112
+#define ARIZONA_DSP1_WDMA_BUFFER_4               0x1113
+#define ARIZONA_DSP1_WDMA_BUFFER_5               0x1114
+#define ARIZONA_DSP1_WDMA_BUFFER_6               0x1115
+#define ARIZONA_DSP1_WDMA_BUFFER_7               0x1116
+#define ARIZONA_DSP1_WDMA_BUFFER_8               0x1117
+#define ARIZONA_DSP1_RDMA_BUFFER_1               0x1120
+#define ARIZONA_DSP1_RDMA_BUFFER_2               0x1121
+#define ARIZONA_DSP1_RDMA_BUFFER_3               0x1122
+#define ARIZONA_DSP1_RDMA_BUFFER_4               0x1123
+#define ARIZONA_DSP1_RDMA_BUFFER_5               0x1124
+#define ARIZONA_DSP1_RDMA_BUFFER_6               0x1125
+#define ARIZONA_DSP1_WDMA_CONFIG_1               0x1130
+#define ARIZONA_DSP1_WDMA_CONFIG_2               0x1131
+#define ARIZONA_DSP1_RDMA_CONFIG_1               0x1134
 #define ARIZONA_DSP1_SCRATCH_0                   0x1140
 #define ARIZONA_DSP1_SCRATCH_1                   0x1141
 #define ARIZONA_DSP1_SCRATCH_2                   0x1142
-- 
1.7.2.5

