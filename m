Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbaLBH6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:58:05 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:45205 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbaLBH6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:58:00 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com,
        shuahkh@osg.samsung.com
Subject: [PATCH V6 8/9] selftests, powerpc: Make GIT ignore all binaries related to TM
Date: Tue,  2 Dec 2014 13:26:52 +0530
Message-Id: <1417507013-11948-9-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120207-0033-0000-0000-000000A5D657
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes all the TM test binaries into the .gitignore
file listing in the same directory. This will make sure that GIT
ignores all of them while displaying status.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 tools/testing/selftests/powerpc/tm/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/powerpc/tm/.gitignore

diff --git a/tools/testing/selftests/powerpc/tm/.gitignore b/tools/testing/selftests/powerpc/tm/.gitignore
new file mode 100644
index 0000000..71f9f9d
--- /dev/null
+++ b/tools/testing/selftests/powerpc/tm/.gitignore
@@ -0,0 +1,2 @@
+tm-ptrace
+tm-resched-dscr
-- 
1.9.3

