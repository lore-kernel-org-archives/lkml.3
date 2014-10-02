Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaJBHEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:04:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39149 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751066AbaJBHEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:04:54 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        m.chehab@samsung.com, crope@iki.fi, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MAINTAINERS: fix Mike Miller's e-mail address
Date: Thu,  2 Oct 2014 09:04:38 +0200
Message-Id: <1412233478-17115-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces Mike Miller's e-mail address
(now rejected by the HP mail server) by the
latest one that he used to submit patches.

Checked that this one is not rejected.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 37054306dc9f..6a8677b5ba24 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4230,7 +4230,7 @@ F:	include/linux/cciss*.h
 F:	include/uapi/linux/cciss*.h
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
-M:	Mike Miller <mike.miller@hp.com>
+M:	Mike Miller <mikem@beardog.cce.hp.com>
 L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/blockdev/cciss.txt
-- 
1.9.1

