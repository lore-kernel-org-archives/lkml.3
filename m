Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab3K0MsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:48:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab3K0MsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:48:14 -0500
Date: Wed, 27 Nov 2013 13:48:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] swiotlb: update format
Message-ID: <alpine.LNX.2.00.1311271347290.14638@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/kernel-parameters.txt doesn't contain up-to-date 
documentation regarding swiotlb= parameter. Update it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/kernel-parameters.txt |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a5..5577634 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3061,7 +3061,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			controller if no parameter or 1 is given or disable
 			it if 0 is given (See Documentation/cgroups/memory.txt)
 
-	swiotlb=	[IA-64] Number of I/O TLB slabs
+	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
+			Format: { <int> | force }
+			<int> -- Number of I/O TLB slabs
+			force -- force using of bounce buffers even if they
+			         wouldn't be automatically used by the kernel
 
 	switches=	[HW,M68k]
 
-- 
Jiri Kosina
SUSE Labs
