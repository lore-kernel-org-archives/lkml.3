Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3HBQWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:22:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10320 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab3HBQWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:22:41 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=KViPC2KJSJUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9PIqHhtn2gcA:10 a=VwQbUJbxAAAA:8 a=L4NsSMfQA-vvXwf8xIAA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375460559.22073.4.camel@gandalf.local.home>
Subject: Re: [PATCH 0/4 v2] [GIT PULL][RCU][3.12] tracing/rcu: Export
 strings to userspace
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 02 Aug 2013 12:22:39 -0400
In-Reply-To: <20130802155111.GA3836@linux.vnet.ibm.com>
References: <20130802023933.677590002@goodmis.org>
	 <20130802155111.GA3836@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 08:51 -0700, Paul E. McKenney wrote:

> I have merged these into v3.11-rc3 in my local tree like this:
> 
> # git log --pretty=oneline v3.11-rc3..
> a6f8eb9e4c18ba0e9a2ed4d2dec888440da12549 Merge branch 'ftrace/rcu-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into rostedt.2013.08.02a
> f7f7bac9cb1c50783f15937a11743655a5756a36 rcu: Have the RCU tracepoints use the tracepoint_string infrastructure
> a41bfeb2f8ed59410be7ca0f8fbc6138a758b746 rcu: Simplify RCU_STATE_INITIALIZER() macro
> e66c33d579ea566d10e8c8695a7168aae3e02992 rcu: Add const annotation to char * for RCU tracepoints and functions
> 102c9323c35a83789ad5ebd3c45fa8fb389add88 tracing: Add __tracepoint_string() to export string pointers
> 
> Amazingly enough, there is only one trivial conflict with the current
> 3.12 RCU commits, so my plan is to treat these commits as a separate
> topic branch for RCU.

Sounds good. Thanks!

-- Steve


