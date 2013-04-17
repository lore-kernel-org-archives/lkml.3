Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617Ab3DQBYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:24:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60838 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab3DQBYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:24:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, Chen Gang <gang.chen@asianux.com>
Subject: [PATCH 0/2] posix_timers: A few expiry caching fixes
Date: Wed, 17 Apr 2013 03:24:01 +0200
Message-Id: <1366161843-26098-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This v2 only updates the changelogs to describe more explicitly
the user visible effects as you suggested.

I dropped the 3rd patch for now because it needs more thinking.

Thanks.


Frederic Weisbecker (2):
  posix-timers: correctly get dying task time sample in
    posix_cpu_timer_schedule()
  posix_timers: Fix racy timer delta caching on task exit

 kernel/posix-cpu-timers.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

-- 
1.7.5.4

