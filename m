Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaAXWrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:47:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaAXWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:47:29 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "W. Trevor King" <wking@tremily.us>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] rel-html: update documentation on contribution process using the DCO
Date: Fri, 24 Jan 2014 14:46:33 -0800
Message-Id: <1390603593-27728-12-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DCO conversation is over and we no longer have to rely on some
questionable URL / project / etc. After discussions with folks from
the Linux Foundation we now have a reasonable document and home page
for the DCO as a project in itself, any project can embrace this DCO.

The shiny new DCO project page:

http://developercertificate.org/

Cc: W. Trevor King <wking@tremily.us>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 CONTRIBUTING | 54 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/CONTRIBUTING b/CONTRIBUTING
index 194038e..f288959 100644
--- a/CONTRIBUTING
+++ b/CONTRIBUTING
@@ -1,7 +1,49 @@
-This project tracks patch provenance and licensing using the Developer
-Certificate of Origin and Signed-off-by tags initially developed by
-the Linux kernel project.  Because the documentation for this
-procedure is licensed under the GPLv2, we have chosen not to include
-it in our project directly.  Instead, please see:
 
-  http://git.tremily.us/?p=signed-off-by.git;a=blob;f=Documentation/SubmittingPatches;h=34055986ab836553896f091225448c448a4cc62c;hb=refs/heads/signed-off-by
+This project embraces the Developer Certificate of Origin (DCO) for
+contributions. This means you must agree to the following prior to submitting
+patches, if you agree with this developer certificate you acknowledge this by
+adding a Signed-off-by tag to your patch commit log. Every submitted patch
+must have this.
+
+The source for the DCO:
+
+http://developercertificate.org/
+
+-----------------------------------------------------------------------
+
+Developer Certificate of Origin
+Version 1.1
+
+Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
+660 York Street, Suite 102,
+San Francisco, CA 94110 USA
+
+Everyone is permitted to copy and distribute verbatim copies of this
+license document, but changing it is not allowed.
+
+
+Developer's Certificate of Origin 1.1
+
+By making a contribution to this project, I certify that:
+
+(a) The contribution was created in whole or in part by me and I
+    have the right to submit it under the open source license
+    indicated in the file; or
+
+(b) The contribution is based upon previous work that, to the best
+    of my knowledge, is covered under an appropriate open source
+    license and I have the right under that license to submit that
+    work with modifications, whether created in whole or in part
+    by me, under the same open source license (unless I am
+    permitted to submit under a different license), as indicated
+    in the file; or
+
+(c) The contribution was provided directly to me by some other
+    person who certified (a), (b) or (c) and I have not modified
+    it.
+
+(d) I understand and agree that this project and the contribution
+    are public and that a record of the contribution (including all
+    personal information I submit with it, including my sign-off) is
+    maintained indefinitely and may be redistributed consistent with
+    this project or the open source license(s) involved.
-- 
1.8.5.2

