Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaJBHbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:31:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39285 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbaJBHbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:31:45 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: storagedev@hp.com, davem@davemloft.net, gregkh@linuxfoundation.org,
        joe@perches.com, m.chehab@samsung.com, crope@iki.fi,
        jg1.han@samsung.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MAINTAINERS: remove Chirag Kantharia, invalid e-mail
Date: Thu,  2 Oct 2014 09:31:34 +0200
Message-Id: <1412235094-17520-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes Chirag Kantharia from the MAINTAINERS file,
as his e-mail address is now rejected by the HP mail server.

Making the driver "Orphan" until he gets back
with a working e-mail address or a new maintainer steps in.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 37054306dc9f..b2e3f7697d39 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4214,9 +4214,8 @@ S:	Maintained
 F:	drivers/media/dvb-frontends/hd29l2*
 
 HEWLETT-PACKARD SMART2 RAID DRIVER
-M:	Chirag Kantharia <chirag.kantharia@hp.com>
 L:	iss_storagedev@hp.com
-S:	Maintained
+S:	Orphan
 F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
-- 
1.9.1

