Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaBMVf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:35:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39883 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaBMVfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:35:24 -0500
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] MAINTAINERS: Add Mauro and me as interim patch collectors
Date: Thu, 13 Feb 2014 22:35:16 +0100
Message-Id: <1392327316-15789-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We're more or less collecting EDAC patches already anyway so let's hold
it down so that get_maintainer sees it too.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fee5e94b0d5e..5cded4b19918 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3082,6 +3082,8 @@ F:	fs/ecryptfs/
 
 EDAC-CORE
 M:	Doug Thompson <dougthompson@xmission.com>
+M:	Borislav Petkov <bp@alien8.de>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Supported
-- 
1.8.5.2.192.g7794a68

