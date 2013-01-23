Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3AWHWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:22:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18284 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3AWHVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:21:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 22 Jan 2013 23:20:18 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>, <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <linux-serial@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] serial: tegra: Fix compilation error
Date: Wed, 23 Jan 2013 12:52:13 +0530
Message-ID: <1358925733-20206-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation error, by adding the correct header file
for Tegra clocks.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/tty/serial/serial-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 30d6ff6..4f5e629 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -43,7 +43,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 
 #define TEGRA_UART_TYPE				"TEGRA_UART"
 #define TX_EMPTY_STATUS				(UART_LSR_TEMT | UART_LSR_THRE)
-- 
1.7.0.4

