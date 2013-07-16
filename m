Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3GPIWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:22:52 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:1217 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab3GPIW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:22:26 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 3/3] ptrace.2: add description for PTRACE_{GET,SET}SIGMASK
Date: Tue, 16 Jul 2013 12:19:33 +0400
Message-Id: <1373962773-2041-4-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373962773-2041-1-git-send-email-avagin@openvz.org>
References: <1373962773-2041-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two commands allow to examine and change mask of blocked signals.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 man2/ptrace.2 | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/man2/ptrace.2 b/man2/ptrace.2
index e74535e..08697ff 100644
--- a/man2/ptrace.2
+++ b/man2/ptrace.2
@@ -356,6 +356,21 @@ If this flag is not set, signals are read from a per-thread queue.
 .in
 .PP
 .TP
+.BR PTRACE_GETSIGMASK " (since Linux 3.11)"
+.\" commit 29000caecbe87b6b66f144f72111f0d02fbbf0c1
+Retrieve mask of blocked signals to the address
+.I data.
+The
+.I addr
+argument contains the size of mask.
+.TP
+.BR PTRACE_SETSIGMASK " (since Linux 3.11)"
+Change mask of blocked signals from the address
+.I data.
+The
+.I addr
+argument contains the size of mask.
+.TP
 .BR PTRACE_SETOPTIONS " (since Linux 2.4.6; see BUGS for caveats)"
 Set ptrace options from
 .IR data .
-- 
1.8.3.1

