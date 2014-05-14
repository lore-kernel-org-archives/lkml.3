Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaENSYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:24:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:60104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaENSY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:24:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1053,1389772800"; 
   d="scan'208";a="539094659"
Subject: [PATCH] net: driver: samsung: keep off in Kconfig by default
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        siva.kallam@samsung.com, vipul.pandya@samsung.com, ks.giri@samsung.com,
        joe@perches.com, bh74.an@samsung.com, davem@davemloft.net,
        netdev@vger.kernel.org
From: Dave Hansen <dave@sr71.net>
Date: Wed, 14 May 2014 11:24:16 -0700
Message-Id: <20140514182416.106B1904@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

These are a pet peeve of mine: Kconfig options that very few
people need turned on, but that default to y.

I know that this doesn't generate any code by itself, but it
does get in the way of every single person that does an
oldconfig.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Siva Reddy Kallam <siva.kallam@samsung.com>
Cc: Vipul Pandya <vipul.pandya@samsung.com>
Cc: Girish K S <ks.giri@samsung.com>
Cc: Joe Perches <joe@perches.com>
Cc: Byungho An <bh74.an@samsung.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---

 b/drivers/net/ethernet/samsung/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/ethernet/samsung/Kconfig~turn-off-samsung-on-by-default drivers/net/ethernet/samsung/Kconfig
--- a/drivers/net/ethernet/samsung/Kconfig~turn-off-samsung-on-by-default	2014-05-14 11:17:06.213259966 -0700
+++ b/drivers/net/ethernet/samsung/Kconfig	2014-05-14 11:17:14.440628851 -0700
@@ -4,7 +4,6 @@
 
 config NET_VENDOR_SAMSUNG
 	bool "Samsung Ethernet devices"
-	default y
 	---help---
 	  If you have a network (Ethernet) chipset belonging to this class,
 	  say Y.
_
