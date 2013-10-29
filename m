Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab3J2Rrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:47:37 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56168 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3J2Rrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:47:36 -0400
From: Robert Richter <rric@kernel.org>
To: Rob Herring <rob.herring@calxeda.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] edac, highbank: Add MAINTAINERS entry
Date: Tue, 29 Oct 2013 18:47:08 +0100
Message-Id: <1383068828-7766-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So taking over maintainership for the EDAC highbank driver.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3438384..2d9ffd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3047,6 +3047,14 @@ W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/amd64_edac*
 
+EDAC-CALXEDA
+M:	Doug Thompson <dougthompson@xmission.com>
+M:	Robert Richter <rric@kernel.org>
+L:	linux-edac@vger.kernel.org
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+F:	drivers/edac/highbank*
+
 EDAC-CAVIUM
 M:	Ralf Baechle <ralf@linux-mips.org>
 M:	David Daney <david.daney@cavium.com>
-- 
1.8.4.rc3

