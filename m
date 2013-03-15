Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3CORCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:02:49 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:57140 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab3CORCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:02:48 -0400
From: Nicolas Schichan <nschichan@freebox.fr>
To: Will Drewry <wad@chromium.org>
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] seccomp: allow BPF_XOR based ALU instructions.
Date: Fri, 15 Mar 2013 18:02:00 +0100
Message-Id: <1363366923-6269-1-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---
 kernel/seccomp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 5af44b5..b7a1004 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -160,6 +160,8 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
 		case BPF_S_ALU_AND_X:
 		case BPF_S_ALU_OR_K:
 		case BPF_S_ALU_OR_X:
+		case BPF_S_ALU_XOR_K:
+		case BPF_S_ALU_XOR_X:
 		case BPF_S_ALU_LSH_K:
 		case BPF_S_ALU_LSH_X:
 		case BPF_S_ALU_RSH_K:
-- 
1.7.10.4

