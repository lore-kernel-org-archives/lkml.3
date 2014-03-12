Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaCLKcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:32:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40872 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbaCLKca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:32:30 -0400
X-IronPort-AV: E=Sophos;i="4.97,636,1389715200"; 
   d="scan'208";a="9683573"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/3 for-tip] use task_nice() in tracing to git rid of an open coded impolementation of it.
Date: Wed, 12 Mar 2014 18:26:41 +0800
Message-Id: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 18:26:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 18:26:34,
	Serialize complete at 2014/03/12 18:26:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,
	The [1/3] in this thread is a copy of 

1390430505-17234-1-git-send-email-yangds.fnst@cn.fujitsu.com.

	At that time, you said you will take this patch if task_nice()
is implemeted as a inline function. Now it is done, I wish you can give
it an ack. If you have a time, please take a look at the other patches
in this thread. Thank you.

Dongsheng Yang (3):
  tracing: Use inline task_nice() to get rid of an open coded
    implementation of it.
  sched/prio: Replace hardcoding of 40 with NICE_WIDTH.
  sched: Use clamp() and clamp_val() to make it more readable.

 kernel/sched/core.c  | 11 ++---------
 kernel/trace/trace.c |  2 +-
 2 files changed, 3 insertions(+), 10 deletions(-)

-- 
1.8.2.1

