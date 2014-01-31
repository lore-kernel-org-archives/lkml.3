Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaAaVpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:45:07 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:48292 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaAaVpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:45:03 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, sasha.levin@oracle.com,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 1/2] tools: lockdep: fix include of asm/hash.h
Date: Fri, 31 Jan 2014 13:35:31 -0800
Message-Id: <1391204132-14071-2-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391204132-14071-1-git-send-email-iws@ovro.caltech.edu>
References: <1391204132-14071-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (ovro.ovro.caltech.edu [0.0.0.0]); Fri, 31 Jan 2014 13:35:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

Commit 71ae8aac ("lib: introduce arch optimized hash library")
added an include to <linux/hash.h> for setting up an architecture
specific fast hash.

This patch mirrors the fix used for perf, titled "tools: perf: util: fix
include for non x86 architectures".

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 tools/lib/lockdep/uinclude/asm/hash.h | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 tools/lib/lockdep/uinclude/asm/hash.h

diff --git a/tools/lib/lockdep/uinclude/asm/hash.h b/tools/lib/lockdep/uinclude/asm/hash.h
new file mode 100644
index 000000000000..d82b170bb216
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/asm/hash.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_HASH_H
+#define __ASM_GENERIC_HASH_H
+
+/* Stub */
+
+#endif /* __ASM_GENERIC_HASH_H */
-- 
1.8.3.2

