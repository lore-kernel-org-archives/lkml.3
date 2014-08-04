Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaHDRNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:13:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56484 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.391500084@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 76/94] score: Add missing #include <linux/export.h>
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

There is no upstream commit for this, as arch/score/kernel/init_task.c
has been replaced by generic code and <linux/export.h> is included
indirectly by arch/score/mm/init.c.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/score/kernel/init_task.c
+++ b/arch/score/kernel/init_task.c
@@ -23,6 +23,7 @@
 
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/export.h>
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -34,6 +34,7 @@
 #include <linux/proc_fs.h>
 #include <linux/sched.h>
 #include <linux/initrd.h>
+#include <linux/export.h>
 
 #include <asm/sections.h>
 #include <asm/tlb.h>

