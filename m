Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBLPqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:46:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaBLPqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:46:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/4] UM: arch_align_stack() moved to asm/exec.h
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, arnd@arndb.de,
        user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 12 Feb 2014 15:46:07 +0000
Message-ID: <20140212154607.2405.15741.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
References: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_align_stack() moved to asm/exec.h, so change the comment referring to
asm/system.h which no longer exists.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Dike <jdike@addtoit.com>
cc: Richard Weinberger <richard@nod.at>
cc: user-mode-linux-devel@lists.sourceforge.net
---

 arch/um/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index eecc414..f17bca8 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -359,7 +359,7 @@ int singlestepping(void * t)
 /*
  * Only x86 and x86_64 have an arch_align_stack().
  * All other arches have "#define arch_align_stack(x) (x)"
- * in their asm/system.h
+ * in their asm/exec.h
  * As this is included in UML from asm-um/system-generic.h,
  * we can use it to behave as the subarch does.
  */

