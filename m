Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaGJWCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:02:37 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63434 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbaGJV4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:56:54 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 63/83] hsa/radeon: Update module information and version
Date: Fri, 11 Jul 2014 00:54:19 +0300
Message-Id: <1405029279-6894-35-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_module.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_module.c b/drivers/gpu/hsa/radeon/kfd_module.c
index 85069c5..fbfcce6 100644
--- a/drivers/gpu/hsa/radeon/kfd_module.c
+++ b/drivers/gpu/hsa/radeon/kfd_module.c
@@ -27,11 +27,13 @@
 #include <linux/device.h>
 #include "kfd_priv.h"
 
-#define DRIVER_AUTHOR		"Andrew Lewycky, Oded Gabbay, Evgeny Pinchuk, others."
+#define KFD_DRIVER_AUTHOR	"AMD Inc. and others"
 
-#define DRIVER_NAME		"kfd"
-#define DRIVER_DESC		"AMD HSA Kernel Fusion Driver"
-#define DRIVER_DATE		"20140127"
+#define KFD_DRIVER_DESC		"Standalone HSA driver for AMD's GPUs"
+#define KFD_DRIVER_DATE		"20140424"
+#define KFD_DRIVER_MAJOR	0
+#define KFD_DRIVER_MINOR	5
+#define KFD_DRIVER_PATCHLEVEL	0
 
 const struct kfd2kgd_calls *kfd2kgd;
 static const struct kgd2kfd_calls kgd2kfd = {
@@ -120,6 +122,9 @@ static void __exit kfd_module_exit(void)
 module_init(kfd_module_init);
 module_exit(kfd_module_exit);
 
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
+MODULE_AUTHOR(KFD_DRIVER_AUTHOR);
+MODULE_DESCRIPTION(KFD_DRIVER_DESC);
+MODULE_LICENSE("GPL and additional rights");
+MODULE_VERSION(__stringify(KFD_DRIVER_MAJOR) "."
+	       __stringify(KFD_DRIVER_MINOR) "."
+	       __stringify(KFD_DRIVER_PATCHLEVEL));
-- 
1.9.1

