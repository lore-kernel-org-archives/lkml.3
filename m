Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaKKOfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:35:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:41009 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaKKOfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:35:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="635075621"
From: Daniel Baluta <daniel.baluta@intel.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org
Cc: joe@perches.com, jic23@kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.baluta@intel.com,
        davem@davemloft.net, mchehab@osg.samsung.com, crope@iki.fi,
        jg1.han@samsung.com
Subject: [PATCH] MAINTAINERS: Add IIO include files
Date: Tue, 11 Nov 2014 16:36:34 +0200
Message-Id: <1415716594-18145-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Files under include/linux/iio were not reported as part
of the IIO subsystem.

Reported-by: Cristina Ciocan <cristina.ciocan@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2f927b..ebb9c38 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4631,6 +4631,7 @@ L:	linux-iio@vger.kernel.org
 S:	Maintained
 F:	drivers/iio/
 F:	drivers/staging/iio/
+F:	include/linux/iio/
 
 IKANOS/ADI EAGLE ADSL USB DRIVER
 M:	Matthieu Castet <castet.matthieu@free.fr>
-- 
1.9.1

