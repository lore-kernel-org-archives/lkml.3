Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaE3HBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:01:10 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:60618 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932093AbaE3HBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:01:08 -0400
Message-ID: <1401433265.6101.0.camel@x220>
Subject: [PATCH] [TRIVIAL] Fix typo 'SCSI_NCR_SETUP_MASTER_PARITY'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 30 May 2014 09:01:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2014 07:01:06.0321 (UTC) FILETIME=[ED662010:01CF7BD4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/scsi/ncr53c8xx.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
index cda5f8fa2c66..1d508dcbf859 100644
--- a/Documentation/scsi/ncr53c8xx.txt
+++ b/Documentation/scsi/ncr53c8xx.txt
@@ -1095,7 +1095,7 @@ SCSI_NCR_SETUP_FORCE_SYNC_NEGO	(default: not defined)
 SCSI_NCR_SETUP_MASTER_PARITY	(default: defined)
 	If defined, master parity checking is enabled.
 
-SCSI_NCR_SETUP_MASTER_PARITY	(default: defined)
+SCSI_NCR_SETUP_SCSI_PARITY	(default: defined)
 	If defined, SCSI parity checking is enabled.
 
 SCSI_NCR_PROFILE_SUPPORT	(default: not defined)
-- 
1.9.3

