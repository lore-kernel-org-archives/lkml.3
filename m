Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbaCRUyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:54:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:18752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933254AbaCRUx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172545"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 13/13] mei: me: bump hbm version to 1.1 to support power gating
Date: Tue, 18 Mar 2014 22:52:07 +0200
Message-Id: <1395175927-10562-14-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Communicate hbm version 1.1 to firmware to tell that we
now support power gating isolation protocol

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 9bad9cf..dd448e5 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -37,7 +37,7 @@
 /*
  * MEI Version
  */
-#define HBM_MINOR_VERSION                   0
+#define HBM_MINOR_VERSION                   1
 #define HBM_MAJOR_VERSION                   1
 
 /*
-- 
1.8.5.3

