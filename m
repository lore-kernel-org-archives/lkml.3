Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3GPIWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:22:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32189 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab3GPIWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:22:25 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 1/3] ptrace.2: place GETSIGINFO and SETSIGINFO near each other
Date: Tue, 16 Jul 2013 12:19:31 +0400
Message-Id: <1373962773-2041-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373962773-2041-1-git-send-email-avagin@openvz.org>
References: <1373962773-2041-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 man2/ptrace.2 | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/man2/ptrace.2 b/man2/ptrace.2
index 0d77e3f..5fcac2b 100644
--- a/man2/ptrace.2
+++ b/man2/ptrace.2
@@ -255,18 +255,6 @@ On return, the kernel modifies
 .B iov.len
 to indicate the actual number of bytes returned.
 .TP
-.BR PTRACE_GETSIGINFO " (since Linux 2.3.99-pre6)"
-Retrieve information about the signal that caused the stop.
-Copy a
-.I siginfo_t
-structure (see
-.BR sigaction (2))
-from the tracee to the address
-.I data
-in the tracer.
-.RI ( addr
-is ignored.)
-.TP
 .BR PTRACE_SETREGS ", " PTRACE_SETFPREGS
 Modify the tracee's general-purpose or floating-point registers,
 respectively, from the address
@@ -301,6 +289,18 @@ and
 is analogous to
 .BR PTRACE_GETREGSET .
 .TP
+.BR PTRACE_GETSIGINFO " (since Linux 2.3.99-pre6)"
+Retrieve information about the signal that caused the stop.
+Copy a
+.I siginfo_t
+structure (see
+.BR sigaction (2))
+from the tracee to the address
+.I data
+in the tracer.
+.RI ( addr
+is ignored.)
+.TP
 .BR PTRACE_SETSIGINFO " (since Linux 2.3.99-pre6)"
 Set signal information:
 copy a
-- 
1.8.3.1

