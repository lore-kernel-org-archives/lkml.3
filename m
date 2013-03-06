Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab3CFQHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:07:07 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:55252 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CFQHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:07:05 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 0/2] sched: Lower chances of cputime scaling overflow v2
Date: Wed,  6 Mar 2013 17:06:53 +0100
Message-Id: <1362586015-27951-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This new set handles the div64_u64_rem() implementation in 32 bits.
If no comment arise I'll test further the 32 bits case then send a pull
request to Ingo.

Thanks.

Frederic Weisbecker (2):
  math64: New div64_u64_rem helper
  sched: Lower chances of cputime scaling overflow

 include/linux/math64.h |   19 ++++++++++++++++++-
 kernel/sched/cputime.c |   31 +++++++++++++++++++------------
 lib/div64.c            |   19 +++++++++++++------
 3 files changed, 50 insertions(+), 19 deletions(-)

-- 
1.7.5.4

