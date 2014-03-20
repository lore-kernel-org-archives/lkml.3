Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaCTOLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:11:22 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:49255 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006AbaCTOLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:11:17 -0400
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        colin.king@canonical.com, bjking1@us.ibm.com, esa@de.ibm.com,
        haver@linux.vnet.ibm.com
Subject: [PATCH 5/5] GenWQE: Increase driver version number
Date: Thu, 20 Mar 2014 15:11:06 +0100
Message-Id: <1395324666-27153-5-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1395324666-27153-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1395324666-27153-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: disable
x-cbid: 14032014-4966-0000-0000-000008CB55C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase genwqe driver version number.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/genwqe_driver.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/genwqe/genwqe_driver.h
+++ b/drivers/misc/genwqe/genwqe_driver.h
@@ -36,7 +36,7 @@
 #include <asm/byteorder.h>
 #include <linux/genwqe/genwqe_card.h>
 
-#define DRV_VERS_STRING		"2.0.0"
+#define DRV_VERS_STRING		"2.0.15"
 
 /*
  * Static minor number assignement, until we decide/implement

