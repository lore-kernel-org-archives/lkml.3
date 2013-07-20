Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3GTDVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 23:21:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3GTDVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 23:21:48 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nwKXD_z5tm8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4Ck8XLREmGMA:10 a=VwQbUJbxAAAA:8 a=6GqWkh2EMPvmWqez68sA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130720032028.963792665@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 23:20:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 0/2] tracing: A couple more fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg sent me a couple more fixes. Pushing them into my for-next branch.
Monday I'll push to Linus.

-- Steve


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: e70e78e3c83b536730e31231dd9b979768d8df3c
1bb539ca36e21c2f4fce0865e11df384bc7b7656


Oleg Nesterov (2):
      tracing: Kill trace_array->waiter
      tracing: Kill the unbalanced tr->ref++ in tracing_buffers_open()

----
 kernel/trace/trace.c |    2 --
 kernel/trace/trace.h |    1 -
 2 files changed, 3 deletions(-)
