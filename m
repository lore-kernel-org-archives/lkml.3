Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaBJJGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:06:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaBJJGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:06:03 -0500
X-IronPort-AV: E=Sophos;i="4.95,816,1384272000"; 
   d="scan'208";a="9497594"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: raistlin@linux.it, juri.lelli@gmail.com, clark.williams@gmail.com,
        peterz@infradead.org, mingo@redhat.com, namhyung@kernel.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/3 V2] sched: Collect the bits about priority into a new header file, include/linux/sched/prio.h.
Date: Mon, 10 Feb 2014 17:05:43 +0800
Message-Id: <cover.1392022452.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/10 17:03:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/10 17:04:01,
	Serialize complete at 2014/02/10 17:04:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
    This patchset is version 2 about priority of sched. Please help to review. 

    Sorry for the late update about it, coming back from vacation.

    v2:
    	* leave the task_prio() in kernel/sched/core.c
    	* remove macro TASK_NICE and implement it as static inline
      	  function in include/linux/sched.h.
	* remove #ifndef when include prio.h.

Dongsheng Yang (3):
  sched: Move the priority specific bits into a new header file.
  sched: Expose some macros related with priority.
  sched: Implement task_nice as static inline function.

 include/linux/sched.h      | 12 +++++++++++-
 include/linux/sched/prio.h | 40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/sched/rt.h   | 19 +------------------
 kernel/sched/core.c        | 26 +++++++-------------------
 kernel/sched/cputime.c     |  4 ++--
 kernel/sched/sched.h       | 18 ------------------
 6 files changed, 61 insertions(+), 58 deletions(-)
 create mode 100644 include/linux/sched/prio.h

-- 
1.8.2.1

