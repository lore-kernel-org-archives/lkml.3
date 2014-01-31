Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbaAaRZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:25:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:33149 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbaAaRZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:25:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,759,1384329600"; 
   d="scan'208";a="467896082"
Subject: [PATCH 2/3] Kconfig: collapse initrd in to own menu
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 31 Jan 2014 09:24:46 -0800
References: <20140131172443.2EDC06E7@viggo.jf.intel.com>
In-Reply-To: <20140131172443.2EDC06E7@viggo.jf.intel.com>
Message-Id: <20140131172446.6E715AEA@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Initrd support takes up 8 lines of space in the general menu,
pushing down options like OProfile or the VM event counters.
Stick it in its own menu to trim it down.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~kconfig-initrd-collapse-in-to-menu init/Kconfig
--- a/init/Kconfig~kconfig-initrd-collapse-in-to-menu	2014-01-31 09:24:17.080453004 -0800
+++ b/init/Kconfig	2014-01-31 09:24:17.084453186 -0800
@@ -1211,7 +1211,7 @@ config RELAY
 
 	  If unsure, say N.
 
-config BLK_DEV_INITRD
+menuconfig BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
 	help
_
