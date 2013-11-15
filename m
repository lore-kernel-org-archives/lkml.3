Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab3KOLBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:01:08 -0500
Received: from lan.nucleusys.com ([92.247.61.126]:40046 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753699Ab3KOLA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:00:59 -0500
X-Greylist: delayed 2172 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Nov 2013 06:00:59 EST
Date: Fri, 15 Nov 2013 12:23:44 +0200
From: Petko Manolov <petkan@nucleusys.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Update Pegasus and RTL8150 driver repositories;
Message-ID: <20131115102344.GA8544@bender.nucleusys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  From: Petko Manolov <petkan@nucleusys.com> Date: Fri, 15 Nov
    2013 11:51:54 +0200 Subject: [PATCH] Update Pegasus and RTL8150 repositories;
    Update Pegasus and RTL8150 driver repositories; The diff is against latest
    'net' repository; [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
 -0.0 RP_MATCHES_RCVD        Envelope sender domain matches handover relay domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Fri, 15 Nov 2013 11:51:54 +0200
Subject: [PATCH] Update Pegasus and RTL8150 repositories;

Update Pegasus and RTL8150 driver repositories;

The diff is against latest 'net' repository;

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
---
 MAINTAINERS | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index afba90c..2295783 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8920,8 +8920,8 @@ USB PEGASUS DRIVER
 M:	Petko Manolov <petkan@nucleusys.com>
 L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
-T:	git git://git.code.sf.net/p/pegasus2/git
-W:	http://pegasus2.sourceforge.net/
+T:	git git://github.com/petkan/pegasus.git
+W:	https://github.com/petkan/pegasus
 S:	Maintained
 F:	drivers/net/usb/pegasus.*
 
@@ -8942,8 +8942,8 @@ USB RTL8150 DRIVER
 M:	Petko Manolov <petkan@nucleusys.com>
 L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
-T:	git git://git.code.sf.net/p/pegasus2/git
-W:	http://pegasus2.sourceforge.net/
+T:	git git://github.com/petkan/rtl8150.git
+W:	https://github.com/petkan/rtl8150
 S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
-- 
1.8.4.2

