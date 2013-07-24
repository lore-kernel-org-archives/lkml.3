Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab3GXDa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:30:58 -0400
Received: from ozlabs.org ([203.10.76.45]:36039 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab3GXDa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:30:57 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net
Subject: [PATCH] perf: Add mailing list to MAINTAINERS
Date: Wed, 24 Jul 2013 13:30:51 +1000
Message-Id: <1374636651-19078-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no mailing list mentioned for perf, but everyone
sends them to lkml, so document that.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..2aae970 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6306,6 +6306,7 @@ M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
 F:	kernel/events/*
-- 
1.8.1.2

