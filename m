Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaA3JQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:16:52 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:45256 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaA3JQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:16:49 -0500
Date: Thu, 30 Jan 2014 10:16:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Aristeu Rozanski <aris@redhat.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 3/6] cgroup: clean up cgroup_subsys names and
 initialization
Message-ID: <20140130091644.GB2749@gmail.com>
References: <1390952641-15950-1-git-send-email-tj@kernel.org>
 <1390952641-15950-4-git-send-email-tj@kernel.org>
 <20140129104648.GC9636@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129104648.GC9636@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jan 28, 2014 at 06:43:58PM -0500, Tejun Heo wrote:
> > * With the above, renaming subsys identifiers to match the userland
> >   visible names doesn't cause any naming conflicts.  All non-matching
> >   identifiers are renamed to match the official names.
> > 
> >   cpu_cgroup -> cpu
> >   perf -> perf_event
> > 
> > Cc: Ingo Molnar <mingo@redhat.com>
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
