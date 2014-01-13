Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaAMXzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:55:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:26900 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071AbaAMXzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:55:21 -0500
Message-Id: <20140113235036.473005178@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 13 Jan 2014 18:50:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/2] ftrace: A few minor fixes
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: a4c35ed241129dd142be4cadb1e5a474a56d5464


Steven Rostedt (Red Hat) (2):
      ftrace: Have function graph only trace based on global_ops filters
      ftrace: Fix synchronization location disabling and freeing ftrace_ops

----
 kernel/trace/ftrace.c | 103 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 76 insertions(+), 27 deletions(-)
