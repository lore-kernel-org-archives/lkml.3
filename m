Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3FEPuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:50:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33423 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3FEPuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:50:39 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] MAINTAINERS: make drivers/clk entry match subdirs
Date: Wed,  5 Jun 2013 09:50:30 -0600
Message-Id: <1370447430-3466-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Modify the drivers/clk MAINTAINERS entry so that it matches the entire
drivers/clk tree, with the exception of clkdev.c which has a separate
entry. Make a similar change to pick up all clk-related header files.

This causes get_maintainers.pl to spit out the expected results for any
patches to clock drivers that are in sub-directories of drivers/clk,
e.g. drivers/clk/tegra/.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fdd0544..e8e4696 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2125,9 +2125,10 @@ M:	Mike Turquette <mturquette@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (same as CLK API & CLKDEV)
 T:	git git://git.linaro.org/people/mturquette/linux.git
 S:	Maintained
-F:	drivers/clk/clk.c
-F:	drivers/clk/clk-*
+F:	drivers/clk/
+X:	drivers/clk/clkdev.c
 F:	include/linux/clk-pr*
+F:	include/linux/clk/
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 M:	Steve French <sfrench@samba.org>
-- 
1.8.1.5

