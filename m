Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaIKM6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:58:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51557 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jack Thomasson" <jkt@moonlitsw.com>,
        "Christian Svensson" <blue@cmd.nu>,
        "Stefan Kristiansson" <stefan.kristiansson@saunalahti.fi>,
        "Jonas Bonn" <jonas@southpole.se>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.829017217@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 095/131] openrisc: add missing header inclusion
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

commit 160d83781a32e94a1e337efd6722939001e62398 upstream.

Prevents build issue with updated toolchain

Reported-by: Jack Thomasson <jkt@moonlitsw.com>
Tested-by: Christian Svensson <blue@cmd.nu>
Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Signed-off-by: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/openrisc/kernel/head.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index b357e7f..1d3c9c2 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -19,6 +19,7 @@
 #include <linux/threads.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/serial_reg.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>

