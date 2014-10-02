Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaJBHpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:45:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39337 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbaJBHps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:45:48 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        m.chehab@samsung.com, crope@iki.fi, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com,
        mikem@beardog.cce.hp.com,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MAINTAINERS: remove iss_storagedev@hp.com list
Date: Thu,  2 Oct 2014 09:45:40 +0200
Message-Id: <1412235940-17628-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the iss_storagedev@hp.com mailing list from the MAINTAINERS
file, as this address is now rejected by the HP mail server.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 37054306dc9f..b0ed53797f43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4215,14 +4215,12 @@ F:	drivers/media/dvb-frontends/hd29l2*
 
 HEWLETT-PACKARD SMART2 RAID DRIVER
 M:	Chirag Kantharia <chirag.kantharia@hp.com>
-L:	iss_storagedev@hp.com
 S:	Maintained
 F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
 M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
-L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/scsi/hpsa.txt
 F:	drivers/scsi/hpsa*.[ch]
@@ -4231,7 +4229,6 @@ F:	include/uapi/linux/cciss*.h
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 M:	Mike Miller <mike.miller@hp.com>
-L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/blockdev/cciss.txt
 F:	drivers/block/cciss*
-- 
1.9.1

