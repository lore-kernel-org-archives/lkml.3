Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaBYWkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:40:32 -0500
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:56795 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753681AbaBYWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:40:28 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:857:901:960:966:967:973:982:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2196:2199:2393:2525:2568:2629:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4385:4659:5007:6119:6261:7809:7903:8599:9010:9025:9149:9388:10004:10026:10049:10848:11232:11257:11657:11658:11914:12043:12517:12519:12555:14094:14106,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: girls33_3f3fc70b7827
X-Filterd-Recvd-Size: 4133
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] MAINTAINERS: Add and correct types of some "T:" entries
Date: Tue, 25 Feb 2014 14:40:26 -0800
Message-Id: <bd80a35e83c4fcd91c9dcab2fb0cef09e09df95c.1393367945.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <7b47ed779e3545c430912c4c4c96096b4ab3161b.1393367945.git.joe@perches.com>
References: <7b47ed779e3545c430912c4c4c96096b4ab3161b.1393367945.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tree location entries should start with the appropriate type.

Add git to some, hg to another.
Neaten tree type description.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 08c519d..2bb43ea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -73,7 +73,8 @@ Descriptions of section entries:
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
 	Q: Patchwork web based patch tracking system site
-	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit, topgit.
+	T: SCM tree type and location.
+	   Type is one of: git, hg, quilt, stgit, topgit
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
@@ -2174,7 +2175,7 @@ F:	Documentation/zh_CN/
 
 CHIPIDEA USB HIGH SPEED DUAL ROLE CONTROLLER
 M:	Peter Chen <Peter.Chen@freescale.com>
-T:	git://github.com/hzpeterchen/linux-usb.git
+T:	git git://github.com/hzpeterchen/linux-usb.git
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/chipidea/
@@ -2404,7 +2405,7 @@ M:	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 L:	linux-pm@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
 S:	Maintained
 F:	drivers/cpuidle/cpuidle-big_little.c
 
@@ -2413,7 +2414,7 @@ M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
 F:	drivers/cpuidle/*
 F:	include/linux/cpuidle.h
 
@@ -4930,7 +4931,7 @@ F:	drivers/staging/ktap/
 KCONFIG
 M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
 L:	linux-kbuild@vger.kernel.org
-T:	git://gitorious.org/linux-kconfig/linux-kconfig
+T:	git git://gitorious.org/linux-kconfig/linux-kconfig
 S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
@@ -5744,7 +5745,7 @@ L:	linux-rdma@vger.kernel.org
 W:	http://www.mellanox.com
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-T:	git://openfabrics.org/~eli/connect-ib.git
+T:	git git://openfabrics.org/~eli/connect-ib.git
 S:	Supported
 F:	drivers/net/ethernet/mellanox/mlx5/core/
 F:	include/linux/mlx5/
@@ -5754,7 +5755,7 @@ M:	Eli Cohen <eli@mellanox.com>
 L:	linux-rdma@vger.kernel.org
 W:	http://www.mellanox.com
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-T:	git://openfabrics.org/~eli/connect-ib.git
+T:	git git://openfabrics.org/~eli/connect-ib.git
 S:	Supported
 F:	include/linux/mlx5/
 F:	drivers/infiniband/hw/mlx5/
@@ -9853,7 +9854,7 @@ ZR36067 VIDEO FOR LINUX DRIVER
 L:	mjpeg-users@lists.sourceforge.net
 L:	linux-media@vger.kernel.org
 W:	http://mjpeg.sourceforge.net/driver-zoran/
-T:	Mercurial http://linuxtv.org/hg/v4l-dvb
+T:	hg http://linuxtv.org/hg/v4l-dvb
 S:	Odd Fixes
 F:	drivers/media/pci/zoran/
 
-- 
1.8.1.2.459.gbcd45b4.dirty

