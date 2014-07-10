Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaGJV5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:52 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48945 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaGJV5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:47 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 83/83] hsa/radeon: Update module version to 0.6.2
Date: Fri, 11 Jul 2014 00:54:39 +0300
Message-Id: <1405029279-6894-55-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version is intended for upstreaming to the Linux kernel 3.17

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_module.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_module.c b/drivers/gpu/hsa/radeon/kfd_module.c
index c706236..c783eeb 100644
--- a/drivers/gpu/hsa/radeon/kfd_module.c
+++ b/drivers/gpu/hsa/radeon/kfd_module.c
@@ -30,10 +30,10 @@
 #define KFD_DRIVER_AUTHOR	"AMD Inc. and others"
 
 #define KFD_DRIVER_DESC		"Standalone HSA driver for AMD's GPUs"
-#define KFD_DRIVER_DATE		"20140623"
+#define KFD_DRIVER_DATE		"20140710"
 #define KFD_DRIVER_MAJOR	0
 #define KFD_DRIVER_MINOR	6
-#define KFD_DRIVER_PATCHLEVEL	1
+#define KFD_DRIVER_PATCHLEVEL	2
 
 const struct kfd2kgd_calls *kfd2kgd;
 static const struct kgd2kfd_calls kgd2kfd = {
-- 
1.9.1

