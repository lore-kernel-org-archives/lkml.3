Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3IBSTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 14:19:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60434 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3IBSTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:19:11 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 11:19:01 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        David Howells <dhowells@redhat.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] checkpatch: Add comment about updating
 Documentation/CodingStyle
Message-ID: <20130902181856.GB29787@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902181510.GA29787@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches to checkpatch that add new style rules should also change
Documentation/CodingStyle to document those new style rules; add a
comment to that effect to the top of scripts/checkpatch.pl.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/checkpatch.pl | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2ee9eb7..ba65ea6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4,6 +4,10 @@
 # (c) 2007,2008, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite)
 # (c) 2008-2010 Andy Whitcroft <apw@canonical.com>
 # Licensed under the terms of the GNU GPL License version 2
+#
+# This file does not define the kernel coding style; Documentation/CodingStyle
+# does.  If you add a new style test to this file, add the corresponding style
+# rule it enforces to Documentation/CodingStyle.
 
 use strict;
 use POSIX;
-- 
1.8.4.rc3

