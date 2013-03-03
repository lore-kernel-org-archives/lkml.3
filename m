Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab3CCB5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:57:12 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:42360 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3CCByQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:16 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Philip Blundell <philb@gnu.org>, netdev@vger.kernel.org
Subject: [PATCH 07/14] MAINTAINERS: remove eexpress
Date: Sat,  2 Mar 2013 22:53:45 -0300
Message-Id: <1362275632-20242-8-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was removed by commit f84932d (drivers/net: delete ISA intel
eexpress and eepro i825xx drivers).

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Philip Blundell <philb@gnu.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2e1443c..92718d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3057,12 +3057,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-hpc.git
 F:	drivers/video/s1d13xxxfb.c
 F:	include/video/s1d13xxxfb.h
 
-ETHEREXPRESS-16 NETWORK DRIVER
-M:	Philip Blundell <philb@gnu.org>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	drivers/net/ethernet/i825xx/eexpress.*
-
 ETHERNET BRIDGE
 M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	bridge@lists.linux-foundation.org
-- 
1.7.11.7

