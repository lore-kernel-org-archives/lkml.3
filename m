Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaA0JSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:18:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaA0JSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:18:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,728,1384272000"; 
   d="scan'208";a="9457823"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: raistlin@linux.it, juri.lelli@gmail.com, clark.williams@gmail.com,
        mingo@redhat.com, rostedt@goodmis.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/3] sched: Collect the bits about priority into a new header file, include/linux/sched/prio.h.
Date: Mon, 27 Jan 2014 17:15:36 -0500
Message-Id: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <20140123065204.4e0b6902@gandalf.local.home>
References: <20140123065204.4e0b6902@gandalf.local.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 17:16:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 17:16:27,
	Serialize complete at 2014/01/27 17:16:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
    This patch set collect the bits about priority in linux/sched/prio.h and
expose some macros about priority here. So that the other parts of core kernel
can use the them without reimplementing it in an open way.

Dongsheng Yang (3):
  sched: Move the priority specific bits into a new header file.
  sched: Expose some macros related with priority.
  sched: Implement task_nice and task_prio as static inline functions.

 include/linux/sched.h      | 30 ++++++++++++++++++++++++++++--
 include/linux/sched/prio.h | 41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/sched/rt.h   | 21 +++------------------
 kernel/sched/core.c        | 25 -------------------------
 kernel/sched/sched.h       | 18 ------------------
 5 files changed, 72 insertions(+), 63 deletions(-)
 create mode 100644 include/linux/sched/prio.h

-- 
1.8.2.1

