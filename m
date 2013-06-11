Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3FKLDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:03:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54480 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3FKLDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:03:35 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/3] sched: Sched Domains: Fixups - Part 3
Date: Tue, 11 Jun 2013 16:32:42 +0530
Message-Id: <cover.1370948150.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter/Ingo,

This set contains few more minor fixes that I could find for code responsible
for creating sched domains. They are rebased of my earlier fixes:

Part 1:
https://lkml.org/lkml/2013/6/4/253

Part 2:
https://lkml.org/lkml/2013/6/10/141

They should be applied in this order to avoid conflicts.

My study of "How scheduling domains are created" is almost over now and so
probably this is my last patchset for fixes related to scheduling domains.

Sorry for three separate sets, I sent them as soon as I had few of them sitting
in my tree.

Viresh Kumar (3):
  sched: Use cached value of span instead of calling
    sched_domain_span()
  sched: don't call get_group() for covered cpus
  sched: remove WARN_ON(!sd) from init_sched_groups_power()

 kernel/sched/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

