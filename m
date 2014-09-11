Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaIKNOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:14:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51524 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jonas Bonn" <jonas@southpole.se>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.948936431@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 098/131] openrisc: include export.h for EXPORT_SYMBOL
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Bonn <jonas@southpole.se>

commit abdf8b5e07884a183938969253770164d60b87cb upstream.

Use of EXPORT_SYMBOL requires inclusion of export.h

Signed-off-by: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/openrisc/kernel/init_task.c | 1 +
 arch/openrisc/kernel/irq.c       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/openrisc/kernel/init_task.c b/arch/openrisc/kernel/init_task.c
index 45744a38..ca53408 100644
--- a/arch/openrisc/kernel/init_task.c
+++ b/arch/openrisc/kernel/init_task.c
@@ -17,6 +17,7 @@
 
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/export.h>
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index 59b3023..4bfead2 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -23,6 +23,7 @@
 #include <linux/irq.h>
 #include <linux/seq_file.h>
 #include <linux/kernel_stat.h>
+#include <linux/export.h>
 
 #include <linux/irqflags.h>
 

