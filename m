Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab3CAE3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 23:29:13 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:47011 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3CAE3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 23:29:12 -0500
From: Vinicius Tinti <viniciustinti@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vinicius Tinti <viniciustinti@gmail.com>
Subject: [PATCH 1/1] arm: remove extra semicolon in if statement
Date: Fri,  1 Mar 2013 01:25:52 -0300
Message-Id: <1362111952-8072-1-git-send-email-viniciustinti@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra semicolon in perf_event.c if statement.

Signed-off-by: Vinicius Tinti <viniciustinti@gmail.com>
---
 arch/arm/kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 31e0eb3..a892067 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -400,7 +400,7 @@ __hw_perf_event_init(struct perf_event *event)
 	}
 
 	if (event->group_leader != event) {
-		if (validate_group(event) != 0);
+		if (validate_group(event) != 0)
 			return -EINVAL;
 	}
 
-- 
1.7.9.5

