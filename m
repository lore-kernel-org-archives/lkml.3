Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaATPBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:01:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16448 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753314AbaATPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:01:07 -0500
Message-Id: <20140120150042.470689818@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 20 Jan 2014 10:00:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/2] tracing: Minor fixes
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 92fdd98cf8bdec4d6b0c510e2f073ac4fd059be8


Al Viro (1):
      tracing: Fix buggered tee(2) on tracing_pipe

Steven Rostedt (Red Hat) (1):
      tracing: Have trace buffer point back to trace_array

----
 kernel/trace/trace.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)
