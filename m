Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaGWBFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:05:16 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56913 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaGWBFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:05:14 -0400
Date: Tue, 22 Jul 2014 18:05:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vineet Gupta <vgupta@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: [patch] mm, arc: remove obsolete pagefault oom killer comment
Message-ID: <alpine.DEB.2.02.1407221804200.21164@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 609838cfed97 ("mm: invoke oom-killer from remaining unconverted page 
fault handlers") converted arc to call pagefault_out_of_memory(), so remove
the comment about future conversion.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/arc/mm/fault.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -159,7 +159,6 @@ good_area:
 		return;
 	}
 
-	/* TBD: switch to pagefault_out_of_memory() */
 	if (fault & VM_FAULT_OOM)
 		goto out_of_memory;
 	else if (fault & VM_FAULT_SIGBUS)
