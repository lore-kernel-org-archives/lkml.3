Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3IXVVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:21:42 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:41277 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750877Ab3IXVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:21:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:2:41:355:379:541:800:960:966:968:973:982:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1535:1593:1594:1606:1730:1747:1777:1792:1801:2196:2199:2393:2538:2559:2562:2737:2828:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:3872:3873:4117:4321:4385:4605:5007:6119:6120:7652:7809:9149:9545:10004:10848:11232:11657:11658:11914:12043:12517:12519:12555:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twist22_65babc9cc4b17
X-Filterd-Recvd-Size: 6038
Message-ID: <1380057697.18695.2.camel@joe-AO722>
Subject: [RFC patch] Update Jens Osterkamp email address
From: Joe Perches <joe@perches.com>
To: Jens Osterkamp <jens@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Sep 2013 14:21:37 -0700
In-Reply-To: <OF686C5618.58B3CEF3-ONC1257BF0.0074538C-C1257BF0.00745392@de.ibm.com>
References: <cover.1380056108.git.joe@perches.com>
	 <OF686C5618.58B3CEF3-ONC1257BF0.0074538C-C1257BF0.00745392@de.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old address isn't working.

Signed-off-by: Joe Perches <joe@perches.com>
---

Maybe if you're still interested in receiving emails
on this old driver...

On Tue, 2013-09-24 at 14:10 -0700, Postmaster@de.ibm.com wrote:
> Your message
>   Subject: [PATCH 08/10] toshiba: Remove extern from function prototypes
> was not delivered to:
>   jens@de.ibm.com
> because:
>   User jens (jens@de.ibm.com) not listed in Domino Directory

 .mailmap                                          | 2 +-
 MAINTAINERS                                       | 2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c      | 2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.h      | 2 +-
 drivers/net/ethernet/toshiba/spider_net.c         | 4 ++--
 drivers/net/ethernet/toshiba/spider_net.h         | 2 +-
 drivers/net/ethernet/toshiba/spider_net_ethtool.c | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/.mailmap b/.mailmap
index 658003a..5dbbad7 100644
--- a/.mailmap
+++ b/.mailmap
@@ -60,7 +60,7 @@ James Ketrenos <jketreno@io.(none)>
 Jean Tourrilhes <jt@hpl.hp.com>
 Jeff Garzik <jgarzik@pretzel.yyz.us>
 Jens Axboe <axboe@suse.de>
-Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
+Jens Osterkamp <jens@linux.vnet.ibm.com>
 John Stultz <johnstul@us.ibm.com>
 Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..f02c3af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7854,7 +7854,7 @@ F:	include/uapi/linux/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
 M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
-M:	Jens Osterkamp <jens@de.ibm.com>
+M:	Jens Osterkamp <jens@linux.vnet.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/spider_net.txt
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index f7f2ef4..7fcdf9a 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -9,7 +9,7 @@
  * (C) Copyright IBM Corp. 2005
  *
  * Authors : Utz Bacher <utz.bacher@de.ibm.com>
- *           Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
+ *           Jens Osterkamp <jens@linux.vnet.ibm.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 8505196..04a50bc 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -9,7 +9,7 @@
  * (C) Copyright IBM Corp. 2005
  *
  * Authors : Utz Bacher <utz.bacher@de.ibm.com>
- *           Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
+ *           Jens Osterkamp <jens@linux.vnet.ibm.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 5734480..6cff915 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -5,7 +5,7 @@
  * (C) Copyright 2006 TOSHIBA CORPORATION
  *
  * Authors : Utz Bacher <utz.bacher@de.ibm.com>
- *           Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
+ *           Jens Osterkamp <jens@linux.vnet.ibm.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -54,7 +54,7 @@
 #include "spider_net.h"
 
 MODULE_AUTHOR("Utz Bacher <utz.bacher@de.ibm.com> and Jens Osterkamp " \
-	      "<Jens.Osterkamp@de.ibm.com>");
+	      "<jens@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("Spider Southbridge Gigabit Ethernet driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(VERSION);
diff --git a/drivers/net/ethernet/toshiba/spider_net.h b/drivers/net/ethernet/toshiba/spider_net.h
index 9b6af08..8545133 100644
--- a/drivers/net/ethernet/toshiba/spider_net.h
+++ b/drivers/net/ethernet/toshiba/spider_net.h
@@ -5,7 +5,7 @@
  * (C) Copyright 2006 TOSHIBA CORPORATION
  *
  * Authors : Utz Bacher <utz.bacher@de.ibm.com>
- *           Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
+ *           Jens Osterkamp <jens@linux.vnet.ibm.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/net/ethernet/toshiba/spider_net_ethtool.c b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
index ffe5193..da27ff3 100644
--- a/drivers/net/ethernet/toshiba/spider_net_ethtool.c
+++ b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
@@ -4,7 +4,7 @@
  * (C) Copyright IBM Corp. 2005
  *
  * Authors : Utz Bacher <utz.bacher@de.ibm.com>
- *           Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
+ *           Jens Osterkamp <jens@linux.vnet.ibm.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by


