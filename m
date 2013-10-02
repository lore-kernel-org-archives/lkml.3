Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3JBNX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:23:29 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39320 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3JBNX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:23:27 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] MAINTAINERS: add acme's tree to perf subsystem
Date: Wed,  2 Oct 2013 18:46:21 +0530
Message-Id: <1380719781-20342-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 744a239..9ef82c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6403,6 +6403,7 @@ M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
 S:	Supported
 F:	kernel/events/*
 F:	include/linux/perf_event.h
-- 
1.8.4.477.g5d89aa9

