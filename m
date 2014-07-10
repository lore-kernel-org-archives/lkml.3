Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaGJV5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:13 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37548 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaGJV5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:08 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 68/83] hsa/radeon: Update module version to 0.6.0
Date: Fri, 11 Jul 2014 00:54:24 +0300
Message-Id: <1405029279-6894-40-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_module.c b/drivers/gpu/hsa/radeon/kfd_module.c
index fbfcce6..33cee3c 100644
--- a/drivers/gpu/hsa/radeon/kfd_module.c
+++ b/drivers/gpu/hsa/radeon/kfd_module.c
@@ -32,7 +32,7 @@
 #define KFD_DRIVER_DESC		"Standalone HSA driver for AMD's GPUs"
 #define KFD_DRIVER_DATE		"20140424"
 #define KFD_DRIVER_MAJOR	0
-#define KFD_DRIVER_MINOR	5
+#define KFD_DRIVER_MINOR	6
 #define KFD_DRIVER_PATCHLEVEL	0
 
 const struct kfd2kgd_calls *kfd2kgd;
-- 
1.9.1

