Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaC1Qph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:45:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37292 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaC1Qpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:45:35 -0400
Message-ID: <5335A72D.50401@infradead.org>
Date: Fri, 28 Mar 2014 09:45:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: resume as Documentation maintainer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

I am the new kernel tree Documentation maintainer
(except for parts that are handled by other people, of course).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Rob Landley <rob@landley.net>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Please resend any outstanding patches to me.

--- lnx-314-rc8.orig/MAINTAINERS
+++ lnx-314-rc8/MAINTAINERS
@@ -2801,9 +2801,9 @@ S:	Supported
 F:	drivers/acpi/dock.c
 
 DOCUMENTATION
-M:	Rob Landley <rob@landley.net>
+M:	Randy Dunlap <rdunlap@infradead.org>
 L:	linux-doc@vger.kernel.org
-T:	TBD
+T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
 S:	Maintained
 F:	Documentation/
 
