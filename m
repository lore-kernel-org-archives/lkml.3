Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3KDRJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:09:08 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44514 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3KDRI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:08:26 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 9/9] GenWQE: Increment driver internal version number
Date: Mon,  4 Nov 2013 18:08:09 +0100
Message-Id: <1383584889-21594-10-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-2966-0000-0000-0000093F31B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version for this release.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/genwqe_driver.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/genwqe/genwqe_driver.h b/drivers/misc/genwqe/genwqe_driver.h
index c8601c9..b8df630 100644
--- a/drivers/misc/genwqe/genwqe_driver.h
+++ b/drivers/misc/genwqe/genwqe_driver.h
@@ -35,7 +35,7 @@
 
 #include <linux/genwqe/genwqe_card.h>
 
-#define DRV_VERS_STRING		"1.1.35"
+#define DRV_VERS_STRING		"2.0.0"
 
 /*
  * Static minor number assignement, until we decide/implement
-- 
1.7.1

