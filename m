Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaCKMj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:39:28 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46003 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaCKMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:39:22 -0400
From: Matei Oprea <eu@opreamatei.ro>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Commmunity <firefly@lists.rosedu.org>
Subject: [PATCH] Staging: comedi: ni_daq_dio24: fix a line over 80 characters
Date: Tue, 11 Mar 2014 14:39:12 +0200
Message-Id: <1394541552-14828-1-git-send-email-eu@opreamatei.ro>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a coding style issue.

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Commmunity <firefly@lists.rosedu.org>
---
 drivers/staging/comedi/drivers/ni_daq_dio24.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 335ea34..925e82c 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -3,8 +3,8 @@
     Driver for National Instruments PCMCIA DAQ-Card DIO-24
     Copyright (C) 2002 Daniel Vecino Castel <dvecino@able.es>
 
-    PCMCIA crap at end of file is adapted from dummy_cs.c 1.31 2001/08/24 12:13:13
-    from the pcmcia package.
+    PCMCIA crap at end of file is adapted from dummy_cs.c 1.31
+    2001/08/24 12:13:13 from the pcmcia package.
     The initial developer of the pcmcia dummy_cs.c code is David A. Hinds
     <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
     are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
-- 
1.7.9.5

