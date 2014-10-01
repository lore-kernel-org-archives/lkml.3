Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaJAJ71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:59:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33244 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbaJAJ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:59:26 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: vgupta@synopsys.com
Cc: richard@nod.at, pebolle@tiscali.nl, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARC: [plat-arcfpga]: remove unused Kconfig params
Date: Wed,  1 Oct 2014 11:59:17 +0200
Message-Id: <1412157557-6975-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
Kconfig parameters which are no longer used anywhere
in the source code and Makefiles.

This also updates a comment refering to these parameters.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arc/plat-arcfpga/Kconfig | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index b9f34cf55acf..3f6814aa97ac 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -12,23 +12,10 @@ menuconfig ARC_PLAT_FPGA_LEGACY
 	help
 	  Support for ARC development boards, provided by Synopsys.
 	  These are based on FPGA or ISS. e.g.
-	  - ARCAngel4
-	  - ML509
 	  - MetaWare ISS
 
 if ARC_PLAT_FPGA_LEGACY
 
-config ARC_BOARD_ANGEL4
-	bool "ARC Angel4"
-	default y
-	help
-	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
-
-config ARC_BOARD_ML509
-	bool "ML509"
-	help
-	  ARC ML509 FPGA Ref Platform (Xilinx Virtex-5 Based)
-
 config ISS_SMP_EXTN
 	bool "ARC SMP Extensions (ISS Models only)"
 	default n
-- 
1.9.1

