Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab3FJK6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:58:24 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64108 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3FJK6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:58:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/3] sched: Sched Domains: Fixups
Date: Mon, 10 Jun 2013 16:27:17 +0530
Message-Id: <cover.1370861520.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter/Ingo,

These are minor fixes that I could find for code responsible for creating sched
domains. They are rebased of my earlier fixes:

https://lkml.org/lkml/2013/6/4/253

I couldn't find them in linux-next or tip/master and so giving this link.

Viresh Kumar (3):
  sched: don't initialize alloc_state in build_sched_domains
  sched: don't sd->child to NULL when it is already NULL
  sched: Create for_each_sd_topology()

 kernel/sched/core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

