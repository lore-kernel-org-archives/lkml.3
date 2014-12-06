Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaLFVjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 16:39:03 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50541 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaLFVjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 16:39:00 -0500
Date: Sat, 6 Dec 2014 16:38:57 -0500
From: John de la Garza <john@jjdev.com>
To: gregkh@linuxfoundation.org
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kobject: grammar fix
Message-ID: <20141206213855.GA28806@vega.jjdev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John de la Garza <john@jjdev.com>
---
 Documentation/kobject.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index f87241d..1be59a3 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -173,7 +173,7 @@ This should be done only after any attributes or children of the kobject
 have been initialized properly, as userspace will instantly start to look
 for them when this call happens.
 
-When the kobject is removed from the kernel (details on how to do that is
+When the kobject is removed from the kernel (details on how to do that are
 below), the uevent for KOBJ_REMOVE will be automatically created by the
 kobject core, so the caller does not have to worry about doing that by
 hand.
-- 
2.1.1

