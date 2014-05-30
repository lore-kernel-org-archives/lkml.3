Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbaE3PYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:24:31 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47473 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058AbaE3PY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:24:29 -0400
Date: Fri, 30 May 2014 17:24:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.w.shin@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 3/4] perf tools: add hardware breakpoint bp_len test cases
Message-ID: <20140530152423.GD25555@localhost.localdomain>
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-4-git-send-email-fweisbec@gmail.com>
 <53889A75.7060105@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53889A75.7060105@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 09:49:25AM -0500, Suravee Suthikulanit wrote:
> On 5/29/2014 10:26 AM, Frederic Weisbecker wrote:
> >@@ -1389,6 +1432,21 @@ static struct evlist_test test__events[] = {
> >  		.check = test__pinned_group,
> >  		.id    = 41,
> >  	},
> >+	{
> >+		.name  = "mem:0/1",
> >+		.check = test__checkevent_breakpoint_len,
> >+		.id    = 42,
> >+	},
> >+	{
> >+		.name  = "mem:0/2:w",
> >+		.check = test__checkevent_breakpoint_len_w,
> >+		.id    = 43,
> >+	},
> >+	{
> >+		.name  = "mem:0/4:rw:u",
> >+		.check = test__checkevent_breakpoint_len_rw_modifier,
> >+		.id    = 44
> >+	},
> >  #if defined(__s390x__)
> >  	{
> >  		.name  = "kvm-s390:kvm_s390_create_vm",
> Frederic,
> 
> This hunk seems to fail to apply on the main tree.  Which tree are
> you working on?

I forgot to say it's rebased on top of:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
	perf/core
 
> Suravee
> 
