Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3IFLt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:49:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41147 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751106Ab3IFLt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:49:26 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: eli@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] mlx5: remove unused MLX5_DEBUG param in Kconfig
Date: Fri,  6 Sep 2013 13:49:22 +0200
Message-Id: <1378468162-3109-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the MLX5_DEBUG kernel configuration
parameter defined in drivers/net/ethernet/mellanox/mlx5/core/Kconfig,
but used nowhere in the makefiles and source code.

This could also be fixed by using this parameter,
but this may be a leftover from driver development...

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 2196282..157fe8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -6,13 +6,3 @@ config MLX5_CORE
 	tristate
 	depends on PCI && X86
 	default n
-
-config MLX5_DEBUG
-	bool "Verbose debugging output" if (MLX5_CORE && EXPERT)
-	depends on MLX5_CORE
-	default y
-	---help---
-	  This option causes debugging code to be compiled into the
-	  mlx5_core driver.  The output can be turned on via the
-	  debug_mask module parameter (which can also be set after
-	  the driver is loaded through sysfs).
-- 
1.8.1.2

