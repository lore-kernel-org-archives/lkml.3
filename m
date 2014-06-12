Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaFLV0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:26:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:32819 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaFLV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:26:40 -0400
Message-ID: <539A1B0B.40406@infradead.org>
Date: Thu, 12 Jun 2014 14:26:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v2] Documentation: exceptions to what I maintain
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Note that I don't maintain Documentation/ABI/,
Documentation/devicetree/, or the language translation files.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

Index: lnx-315-rc5/MAINTAINERS
===================================================================
--- lnx-315-rc5.orig/MAINTAINERS
+++ lnx-315-rc5/MAINTAINERS
@@ -2886,6 +2886,9 @@ L:	linux-doc@vger.kernel.org
 T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
 S:	Maintained
 F:	Documentation/
+X:	Documentation/ABI/
+X:	Documentation/devicetree/
+X:	Documentation/[a-z][a-z]_[A-Z][A-Z]/
 
 DOUBLETALK DRIVER
 M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
