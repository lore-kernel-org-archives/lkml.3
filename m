Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaENVAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:00:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33920 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaENVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:00:41 -0400
Message-ID: <5373D977.1090306@infradead.org>
Date: Wed, 14 May 2014 14:00:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: [PATCH RFC] Documentation: note maintainer exceptions
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
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-315-rc2.orig/MAINTAINERS
+++ lnx-315-rc2/MAINTAINERS
@@ -2885,7 +2885,7 @@ M:	Randy Dunlap <rdunlap@infradead.org>
 L:	linux-doc@vger.kernel.org
 T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
 S:	Maintained
-F:	Documentation/
+F:	Documentation/ (but not: ABI, devicetree, translations)
 
 DOUBLETALK DRIVER
 M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
