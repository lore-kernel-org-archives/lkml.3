Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033AbaGREgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:36:03 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47699 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083AbaGREUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:20:23 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 net-next 02/16] bpf: update MAINTAINERS entry
Date: Thu, 17 Jul 2014 21:19:52 -0700
Message-Id: <1405657206-12060-3-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ae8cd00215b2..32e24ff46da3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1912,6 +1912,13 @@ S:	Supported
 F:	drivers/net/bonding/
 F:	include/uapi/linux/if_bonding.h
 
+BPF (Safe dynamic programs and tools)
+M:	Alexei Starovoitov <ast@kernel.org>
+L:	netdev@vger.kernel.org
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/bpf/
+
 BROADCOM B44 10/100 ETHERNET DRIVER
 M:	Gary Zambrano <zambrano@broadcom.com>
 L:	netdev@vger.kernel.org
-- 
1.7.9.5

