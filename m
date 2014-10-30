Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbaJ3GsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:48:00 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58964 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338AbaJ3Gru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:47:50 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove list iss_storagedev@hp.com
Date: Thu, 30 Oct 2014 12:17:39 +0530
Message-Id: <1414651659-4485-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when sending mail to iss_storagedev@hp.com it failed permanently

"Google tried to deliver your message, but it was rejected by the
server for the recipient domain hp.com by smtp.hp.com.
[15.201.208.57].
The error that the other server returned was:
550 5.1.1 <iss_storagedev@hp.com>: Recipient address
rejected: User unknown in virtual alias table"

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 MAINTAINERS | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2bca5f1..6042da0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4301,14 +4301,12 @@ S:	Maintained
 F:	drivers/media/dvb-frontends/hd29l2*
 
 HEWLETT-PACKARD SMART2 RAID DRIVER
-L:	iss_storagedev@hp.com
 S:	Orphan
 F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
 M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
-L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/scsi/hpsa.txt
 F:	drivers/scsi/hpsa*.[ch]
@@ -4317,7 +4315,6 @@ F:	include/uapi/linux/cciss*.h
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 M:	Mike Miller <mike.miller@hp.com>
-L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/blockdev/cciss.txt
 F:	drivers/block/cciss*
-- 
1.8.1.2

