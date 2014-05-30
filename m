Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaE3H1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:27:49 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:62890 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbaE3H1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:27:48 -0400
Message-ID: <1401434866.6101.3.camel@x220>
Subject: [PATCH] ncr53c8xx: remove remnants of integrity checking
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 May 2014 09:27:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2014 07:27:46.0440 (UTC) FILETIME=[A724E880:01CF7BD8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code for integrity checking was removed in v2.6.10. Remove its
remnants now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/scsi/ncr53c8xx.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index 0e008dacf679..736a9df68d58 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -63,14 +63,6 @@
 #define SCSI_NCR_BOOT_COMMAND_LINE_SUPPORT
 #define SCSI_NCR_DEBUG_INFO_SUPPORT
 
-/*
-**	To disable integrity checking, do not define the 
-**	following option.
-*/
-#ifdef	CONFIG_SCSI_NCR53C8XX_INTEGRITY_CHECK
-#	define SCSI_NCR_ENABLE_INTEGRITY_CHECK
-#endif
-
 /* ---------------------------------------------------------------------
 ** Take into account kernel configured parameters.
 ** Most of these options can be overridden at startup by a command line.
-- 
1.9.3

