Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3HBQNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:13:04 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61630 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab3HBQNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:13:01 -0400
Date: Fri, 02 Aug 2013 09:13:00 -0700 (PDT)
Cc: linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <1375459978.687125@landley.net>
From: Rob Landley <rob@landley.net>
Subject: [PATCH] Tweak Documentation MAINTAINERS entry.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree bindings are well-maintained by the device tree guys and
tend to swamp linux-doc with traffic we can't really say much about (it's
all domain-specific knowledge), so add an X: entry for it.

Similarly, non-english documentation can't be maintained by people who
don't speak those languages. (I argued that translations belonged on the
web when they were proposed, but Greg KH overruled me.)

I habitually ignore these, and cutting down on kernel-doc traffic should
make the rest of the list easier to follow.

Signed-off-by: Rob Landley <rob@landley.net>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d83f70f..6b752df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2664,6 +2664,10 @@ L:	linux-doc@vger.kernel.org
 T:	TBD
 S:	Maintained
 F:	Documentation/
+X:	Documentation/zh_CN
+X:	Documentation/ko_KR
+X:	Documentation/ja_JP
+X:	Documentation/devicetree/bindings
 
 DOUBLETALK DRIVER
 M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
