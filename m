Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaJaKEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:04:48 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51752 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbaJaKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:04:46 -0400
Message-ID: <54535EB7.7090704@hitachi.com>
Date: Fri, 31 Oct 2014 19:04:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 0/4] ftrace: Add dynamic trampoline support
References: <20141027182702.778680710@goodmis.org>
In-Reply-To: <20141027182702.778680710@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/28 3:27), Steven Rostedt wrote:
> This adds the allocation of dynamic trampolines. It still does not
> allow for dynamic ftrace_ops to use them on CONFIG_PREEMPT systems.
> That will come in 3.20, as I want to test out call_rcu_tasks() for
> a bit first on my own boxes.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> for-next
> 
> Head SHA1: 9fd7caf67913fbf35d834beaa8f9764d733a9236

Anyway, usually flush_icache_range() is not so critical. I've tested
this with ftracetest and following 2 testcases :)

http://marc.info/?l=linux-kernel&m=141150834012382
http://marc.info/?l=linux-kernel&m=141353397907456

Tested-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
for this series.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


