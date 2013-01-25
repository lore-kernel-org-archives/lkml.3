Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3AYHr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:47:56 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41598 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3AYHry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:47:54 -0500
X-Greylist: delayed 71786 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 02:47:53 EST
Date: Fri, 25 Jan 2013 08:47:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Message-ID: <20130125074749.GA20868@gmail.com>
References: <5100D4FE.9080205@huawei.com>
 <5100D518.8000103@huawei.com>
 <20130124100134.GC26351@gmail.com>
 <20130124194205.GS2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124194205.GS2373@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> On Thu, Jan 24, 2013 at 11:01:34AM +0100, Ingo Molnar wrote:
> > Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> Ingo, if you don't objecdt, I'll take these through cgroup/for-3.9
> branch with other cgroup changes.  Pleaes holler if you object.

That's fine with me, it should not interact with anything 
pending in (or planned for) the scheduler tree for this cycle.

Thanks,

	Ingo
