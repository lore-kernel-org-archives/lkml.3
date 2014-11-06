Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaKFWla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaKFWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Allen Pais <allen.pais@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 043/162] sparc64: cpu hardware caps support for sparc M6 and M7
Date: Thu,  6 Nov 2014 14:35:07 -0800
Message-Id: <1415313426-9622-44-git-send-email-kamal@canonical.com>
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

[ Upstream commit 408316258521168614bfb4da0e070490d3e65a17 ]

Signed-off-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/setup_64.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 3fdb455..1c7bfdf 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -500,12 +500,16 @@ static void __init init_sparc64_elf_hwcap(void)
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA5 ||
+		    sun4v_chip_type == SUN4V_CHIP_SPARC_M6 ||
+		    sun4v_chip_type == SUN4V_CHIP_SPARC_M7 ||
 		    sun4v_chip_type == SUN4V_CHIP_SPARC64X)
 			cap |= HWCAP_SPARC_BLKINIT;
 		if (sun4v_chip_type == SUN4V_CHIP_NIAGARA2 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA5 ||
+		    sun4v_chip_type == SUN4V_CHIP_SPARC_M6 ||
+		    sun4v_chip_type == SUN4V_CHIP_SPARC_M7 ||
 		    sun4v_chip_type == SUN4V_CHIP_SPARC64X)
 			cap |= HWCAP_SPARC_N2;
 	}
@@ -533,6 +537,8 @@ static void __init init_sparc64_elf_hwcap(void)
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA5 ||
+			    sun4v_chip_type == SUN4V_CHIP_SPARC_M6 ||
+			    sun4v_chip_type == SUN4V_CHIP_SPARC_M7 ||
 			    sun4v_chip_type == SUN4V_CHIP_SPARC64X)
 				cap |= (AV_SPARC_VIS | AV_SPARC_VIS2 |
 					AV_SPARC_ASI_BLK_INIT |
@@ -540,6 +546,8 @@ static void __init init_sparc64_elf_hwcap(void)
 			if (sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA5 ||
+			    sun4v_chip_type == SUN4V_CHIP_SPARC_M6 ||
+			    sun4v_chip_type == SUN4V_CHIP_SPARC_M7 ||
 			    sun4v_chip_type == SUN4V_CHIP_SPARC64X)
 				cap |= (AV_SPARC_VIS3 | AV_SPARC_HPC |
 					AV_SPARC_FMAF);
-- 
1.9.1

