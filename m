Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab3HCMvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 08:51:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3HCMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 08:51:19 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=QzBE9ZvkjS4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pg9iQzu9VWoA:10 a=VwQbUJbxAAAA:8 a=FoXjPa7Cf79mQr6Jh_QA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130803124926.157378122@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 03 Aug 2013 08:49:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 0/4] tracing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this is the last of the fixes for 3.11. Famous last words.
These are some minor bug fixes, but still should be in 3.11 and stable.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 9457158bbc0ee04ecef76862d73eecd8076e9c7b


Alexander Z Lam (2):
      tracing: Make TRACE_ITER_STOP_ON_FREE stop the correct buffer
      tracing: Fix reset of time stamps during trace_clock changes

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by mistake

Dhaval Giani (1):
      tracing: Fix trace_dump_stack() proto when CONFIG_TRACING is not set

----
 include/linux/ftrace_event.h |   10 ++++++----
 include/linux/kernel.h       |    2 +-
 kernel/trace/trace.c         |   27 ++++++++++++++-------------
 3 files changed, 21 insertions(+), 18 deletions(-)
