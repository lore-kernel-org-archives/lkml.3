Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816Ab3DHITI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:19:08 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53535 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558Ab3DHITE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:19:04 -0400
Date: Mon, 8 Apr 2013 16:18:31 +0800
From: Wang YanQing <udknight@gmail.com>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        alex.williamson@redhat.com, joerg.roedel@amd.com
Subject: [PATCH][TRIVIAL] iommu: Include linux/err.h
Message-ID: <20130408081831.GA22583@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, jkosina@suse.cz,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	alex.williamson@redhat.com, joerg.roedel@amd.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux/iommu.h header uses ERR_PTR defined
in linux/err.h but doesn't include it.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 I send this twice to joerg.roedel@amd.com more than one
 month, but it had been ignored, I don't why.

 include/linux/iommu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f3b99e1..f4a49a6 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -20,6 +20,7 @@
 #define __LINUX_IOMMU_H
 
 #include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/types.h>
 
 #define IOMMU_READ	(1)
-- 
1.7.11.1.116.g8228a23
