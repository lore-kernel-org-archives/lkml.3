Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3ITRJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:09:21 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59454 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3ITRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:09:18 -0400
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>,
        "=James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, John Kacur <jkacur@redhat.com>
Subject: [PATCH] [SCSI]: Remove Kconfig text referring to non-existent scsi_wait_scan_module
Date: Fri, 20 Sep 2013 19:09:11 +0200
Message-Id: <1379696951-13648-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scsi_wait_scan_module was removed in linux-3.6 with
commit 6072609d9bb91ff54aee3ef29304bd5b4fc88aae

Remove the text referring to it under config SCSI_SCAN_ASYNC

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/scsi/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index fe25677..49d7768 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -253,13 +253,6 @@ config SCSI_SCAN_ASYNC
 	  system continues booting, and even probe devices on different
 	  busses in parallel, leading to a significant speed-up.
 
-	  If you have built SCSI as modules, enabling this option can
-	  be a problem as the devices may not have been found by the
-	  time your system expects them to have been.  You can load the
-	  scsi_wait_scan module to ensure that all scans have completed.
-	  If you build your SCSI drivers into the kernel, then everything
-	  will work fine if you say Y here.
-
 	  You can override this choice by specifying "scsi_mod.scan=sync"
 	  or async on the kernel's command line.
 
-- 
1.8.1.4

