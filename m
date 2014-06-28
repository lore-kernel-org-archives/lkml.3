Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaF1B27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 21:28:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbaF1B25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 21:28:57 -0400
Message-ID: <53AE1A58.5060505@infradead.org>
Date: Fri, 27 Jun 2014 18:28:56 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: [PATCH 2/2] MAINTAINERS: exceptions for Documentation maintainer
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
