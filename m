Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaCJIyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:54:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47592 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752394AbaCJIya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:54:30 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: joe@perches.com, gregkh@linuxfoundation.org, davem@davemloft.net,
        m.chehab@samsung.com, swarren@nvidia.com, khali@linux-fr.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MAINTAINERS: remove invalid IBM ServeRAID RAID maintainer address
Date: Mon, 10 Mar 2014 09:54:15 +0100
Message-Id: <1394441655-8257-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mail server reply:
Recipient address rejected: User unknown in virtual alias table

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b7befe758429..52ca18df1707 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4297,7 +4297,6 @@ X:	drivers/scsi/ibmvscsi/ibmvstgt.c
 
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer
-M:	Dave Jeffery <ipslinux@adaptec.com>
 W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
 S:	Supported
 F:	drivers/scsi/ips.*
-- 
1.8.3.2

