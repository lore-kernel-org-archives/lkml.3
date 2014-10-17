Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaJQM7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:59:36 -0400
Received: from tex.lwn.net ([70.33.254.29]:60422 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaJQM7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:59:35 -0400
Date: Fri, 17 Oct 2014 08:59:26 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] MAINTAINERS: Become the docs maintainer
Message-ID: <20141017085926.76556bc2@lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems it's my turn to be the documentation maintainer for a bit.  My
plan is to work to ensure that docs patches don't fall through the cracks;
I assume most changes will continue to flow through subsystem-specific
trees.

Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0f17d59078e..3c14f7cde870 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3085,14 +3085,13 @@ S:	Supported
 F:	drivers/acpi/dock.c
 
 DOCUMENTATION
-M:	Jiri Kosina <jkosina@suse.cz>
+M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-doc@vger.kernel.org
 S:	Maintained
 F:	Documentation/
 X:	Documentation/ABI/
 X:	Documentation/devicetree/
 X:	Documentation/[a-z][a-z]_[A-Z][A-Z]/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/doc.git
 
 DOUBLETALK DRIVER
 M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
-- 
1.9.3

