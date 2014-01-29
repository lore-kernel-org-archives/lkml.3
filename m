Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaA2KrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:47:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47192 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA2KrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:47:12 -0500
Date: Wed, 29 Jan 2014 11:46:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Aristeu Rozanski <aris@redhat.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 3/6] cgroup: clean up cgroup_subsys names and
 initialization
Message-ID: <20140129104648.GC9636@twins.programming.kicks-ass.net>
References: <1390952641-15950-1-git-send-email-tj@kernel.org>
 <1390952641-15950-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390952641-15950-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 06:43:58PM -0500, Tejun Heo wrote:
> * With the above, renaming subsys identifiers to match the userland
>   visible names doesn't cause any naming conflicts.  All non-matching
>   identifiers are renamed to match the official names.
> 
>   cpu_cgroup -> cpu
>   perf -> perf_event
> 
> Cc: Ingo Molnar <mingo@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>

