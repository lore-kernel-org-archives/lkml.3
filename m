Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaAaAfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:35:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36559 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaAaAfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:35:39 -0500
Message-ID: <52EAEFD8.6030003@infradead.org>
Date: Thu, 30 Jan 2014 16:35:36 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andiry Xu <andiry.xu@gmail.com>,
        Rob Landley <rob@landley.net>
Subject: [PATCH] Documentation: fix memmap= language in kernel-parameters.txt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Clean up descriptions of memmap= boot options.

Add periods (full stops), drop commas, change "used" to
"reserved" or "marked".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andiry Xu <andiry.xu@gmail.com>
Cc: David Rientjes <rientjes@google.com>
---
 Documentation/kernel-parameters.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- lnx-313.orig/Documentation/kernel-parameters.txt
+++ lnx-313/Documentation/kernel-parameters.txt
@@ -1668,16 +1668,16 @@ bytes respectively. Such letter suffixes
 			option description.
 
 	memmap=nn[KMG]@ss[KMG]
-			[KNL] Force usage of a specific region of memory
-			Region of memory to be used, from ss to ss+nn.
+			[KNL] Force usage of a specific region of memory.
+			Region of memory to be used is from ss to ss+nn.
 
 	memmap=nn[KMG]#ss[KMG]
 			[KNL,ACPI] Mark specific memory as ACPI data.
-			Region of memory to be used, from ss to ss+nn.
+			Region of memory to be marked is from ss to ss+nn.
 
 	memmap=nn[KMG]$ss[KMG]
 			[KNL,ACPI] Mark specific memory as reserved.
-			Region of memory to be used, from ss to ss+nn.
+			Region of memory to be reserved is from ss to ss+nn.
 			Example: Exclude memory from 0x18690000-0x1869ffff
 			         memmap=64K$0x18690000
 			         or
