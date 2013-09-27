Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3I0JLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:11:46 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:33662 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab3I0JLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:11:45 -0400
Message-ID: <52454BE3.1070606@linux.vnet.ibm.com>
Date: Fri, 27 Sep 2013 11:12:03 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] gcov: MAINTAINERS: Add an entry for gcov
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092709-2966-0000-0000-000008E2126B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3605,6 +3605,12 @@
 S:	Odd Fixes (e.g., new signatures)
 F:	drivers/scsi/fdomain.*

+GCOV BASED KERNEL PROFILING
+M:	Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
+S:	Maintained
+F:	kernel/gcov/
+F:	Documentation/gcov.txt
+
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
 M:	Achim Leubner <achim_leubner@adaptec.com>
 L:	linux-scsi@vger.kernel.org

