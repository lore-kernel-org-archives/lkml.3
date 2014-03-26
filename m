Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaCZEIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:08:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:17845 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751451AbaCZEIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:08:06 -0400
Message-Id: <20140326040731.610462407@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 26 Mar 2014 00:07:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/2] tracing: next updates
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 3862807880acc0adaef6749738d210c9f45c3049


Aaron Tomlin (1):
      tracing: Add BUG_ON when stack end location is over written

Mathieu Desnoyers (1):
      tracepoint: Remove unused API functions

----
 include/linux/tracepoint.h |  18 ----
 kernel/trace/trace_stack.c |   3 +
 kernel/tracepoint.c        | 222 +--------------------------------------------
 3 files changed, 8 insertions(+), 235 deletions(-)
