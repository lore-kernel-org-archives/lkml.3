Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaKFXHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:07:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaKFWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:59 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Allen Pais <allen.pais@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/162] sparc64: support M6 and M7 for building CPU distribution map
Date: Thu,  6 Nov 2014 14:35:06 -0800
Message-Id: <1415313426-9622-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Pais <allen.pais@oracle.com>

[ Upstream commit 9bd3ee33f6b97de092610d8dcabc4cb98d99505c ]

Add M6 and M7 chip type in cpumap.c to correctly build CPU distribution map that spans all online CPUs.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/cpumap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/kernel/cpumap.c b/arch/sparc/kernel/cpumap.c
index cb5d272..b031c9c 100644
--- a/arch/sparc/kernel/cpumap.c
+++ b/arch/sparc/kernel/cpumap.c
@@ -327,6 +327,8 @@ static int iterate_cpu(struct cpuinfo_tree *t, unsigned int root_index)
 	case SUN4V_CHIP_NIAGARA3:
 	case SUN4V_CHIP_NIAGARA4:
 	case SUN4V_CHIP_NIAGARA5:
+	case SUN4V_CHIP_SPARC_M6:
+	case SUN4V_CHIP_SPARC_M7:
 	case SUN4V_CHIP_SPARC64X:
 		rover_inc_table = niagara_iterate_method;
 		break;
-- 
1.9.1

