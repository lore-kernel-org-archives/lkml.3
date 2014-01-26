Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaAZFBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 00:01:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:29821 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750839AbaAZFAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 00:00:42 -0500
Message-Id: <20140126045941.796589415@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 25 Jan 2014 23:59:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/3] tracing: Update to README and a small bug fix
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 3132e107d608f8753240d82d61303c500fd515b4


Steven Rostedt (Red Hat) (2):
      tracing: Fix formatting of trace README file
      tracing: Check if tracing is enabled in trace_puts()

Tom Zanussi (1):
      tracing/README: Add event file usage to tracing mini-HOWTO

----
 kernel/trace/trace.c | 113 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 81 insertions(+), 32 deletions(-)
