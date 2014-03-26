Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaCZLVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:21:50 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:52982 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaCZLVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:21:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/14] timers/hrtimers: Minor cleanups
Date: Wed, 26 Mar 2014 16:51:06 +0530
Message-Id: <cover.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I am going through this piece of code to complete my 'cpusets.quiesce' work.
While going through code I accumulated these patches which are mostly code
cleanups and shouldn't have much functional change.

Thanks for applying yesterdays cleanups :)

Viresh Kumar (14):
  hrtimer: replace 'tab' with 'space' after comma ','
  hrtimer: Coalesce format fragments in printk()
  hrtimer: call hrtimer_set_expires_range() from
    hrtimer_set_expires_range_ns()
  hrtimer: use base->index instead of basenum in switch_hrtimer_base()
  hrtimer: no need to rewrite '1' to hrtimer_hres_enabled
  hrtimer: don't rewrite same value to expires_next in
    hrtimer_force_reprogram()
  hrtimer: use base->hres_active directly instead of
    hrtimer_hres_active()
  hrtimer: remove dummy definition of hrtimer_force_reprogram()
  hrtimer: don't check state of base->hres_active in
    hrtimer_switch_to_hres()
  hrtimer: remove clock_was_set_delayed() from hrtimer.h
  hrtimer: remove active_bases field from struct hrtimer_cpu_base
  hrtimer: don't emulate notifier call to initialize timer base
  timer: simplify CPU_UP_PREPARE notifier code path
  timer: don't emulate notifier call to initialize timer base

 include/linux/hrtimer.h | 10 +---------
 kernel/hrtimer.c        | 40 ++++++++++++++--------------------------
 kernel/timer.c          | 12 ++----------
 3 files changed, 17 insertions(+), 45 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

