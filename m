Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaABUUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:20:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:7784 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaABUUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:20:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,592,1384329600"; 
   d="scan'208";a="459244513"
Subject: [PATCH 2/3] Kconfig: collapse initrd in to own menu
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Thu, 02 Jan 2014 12:20:16 -0800
References: <20140102202014.CA206E9B@viggo.jf.intel.com>
In-Reply-To: <20140102202014.CA206E9B@viggo.jf.intel.com>
Message-Id: <20140102202016.7A057719@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Initrd support takes up 8 lines of space in the general menu,
pushing down options like OProfile or the VM event counters.
Stick it in its own menu to trim it down.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~kconfig-initrd-collapse-in-to-menu init/Kconfig
--- linux.git/init/Kconfig~kconfig-initrd-collapse-in-to-menu	2014-01-02 11:23:59.008804083 -0800
+++ linux.git-davehans/init/Kconfig	2014-01-02 11:23:59.011804218 -0800
@@ -1223,7 +1223,7 @@ config RELAY
 
 	  If unsure, say N.
 
-config BLK_DEV_INITRD
+menuconfig BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
 	help
_
