Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaGJWD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:03:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37936 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaGJV4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:56:51 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 61/83] hsa/radeon: change another pr_info to pr_debug
Date: Fri, 11 Jul 2014 00:54:17 +0300
Message-Id: <1405029279-6894-33-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_topology.c b/drivers/gpu/hsa/radeon/kfd_topology.c
index 213ae7b..059b7db 100644
--- a/drivers/gpu/hsa/radeon/kfd_topology.c
+++ b/drivers/gpu/hsa/radeon/kfd_topology.c
@@ -1121,7 +1121,7 @@ int kfd_topology_add_device(struct kfd_dev *gpu)
 
 	gpu_id = kfd_generate_gpu_id(gpu);
 
-	pr_info("Adding new GPU (ID: 0x%x) to topology\n", gpu_id);
+	pr_debug("kfd: Adding new GPU (ID: 0x%x) to topology\n", gpu_id);
 
 	down_write(&topology_lock);
 	/*
-- 
1.9.1

