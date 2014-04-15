Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbaDOFYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:24:52 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56638 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDOFYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:24:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 Resend 0/5] tick: bugfixes
Date: Tue, 15 Apr 2014 10:54:36 +0530
Message-Id: <cover.1397537986.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

As suggested by you (https://lkml.org/lkml/2014/4/14/797), this is the first lot
of changes I have. These are all potential bug fixes (Sorry if I haven't read
the most obvious code correctly at some place :) ).

Patch 2/5 isn't a bug fix but was required as a dependency for 3/5.

Some discussions already happened for 5/5 here:
https://lkml.org/lkml/2014/4/9/243
https://lkml.org/lkml/2014/4/9/346

I have tried to mark stable release wherever possible.

Viresh Kumar (5):
  tick-common: fix wrong check in tick_check_replacement()
  tick-common: don't check tick_oneshot_mode_active() from
    tick_check_preferred()
  tick-common: do additional checks in tick_check_preferred()
  tick-sched: don't call update_wall_time() when delta is lesser than
    tick_period
  tick-sched: replace tick_nohz_active with tick_nohz_enabled in
    tick_nohz_switch_to_nohz()

 kernel/time/tick-common.c | 29 +++++++++++++++++++----------
 kernel/time/tick-sched.c  | 34 ++++++++++++++++++----------------
 2 files changed, 37 insertions(+), 26 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

