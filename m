Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3FNTXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:23:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36460 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3FNTXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:23:48 -0400
Message-ID: <51BB6DB8.1020601@infradead.org>
Date: Fri, 14 Jun 2013 12:23:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>
Subject: [PATCH] docbook: add futexes to kernel-locking docbook
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add Fast User Mutexes (futexes) to kernel-locking docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/DocBook/kernel-locking.tmpl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- lnx-310-rc5.orig/Documentation/DocBook/kernel-locking.tmpl
+++ lnx-310-rc5/Documentation/DocBook/kernel-locking.tmpl
@@ -1955,12 +1955,17 @@ machines due to caching.
    </sect1>
   </chapter>
 
-  <chapter id="apiref">
+  <chapter id="apiref-mutex">
    <title>Mutex API reference</title>
 !Iinclude/linux/mutex.h
 !Ekernel/mutex.c
   </chapter>
 
+  <chapter id="apiref-futex">
+   <title>Futex API reference</title>
+!Ikernel/futex.c
+  </chapter>
+
   <chapter id="references">
    <title>Further reading</title>
 
