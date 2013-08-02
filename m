Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3HBTw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:52:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63603 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3HBTwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:52:54 -0400
Date: Fri, 2 Aug 2013 15:52:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/23] cgroup: pass around cgroup_subsys_state instead of
 cgroup in subsystem methods
Message-ID: <20130802195248.GG29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-9-git-send-email-tj@kernel.org>
 <20130802131901.GB25432@dhcp22.suse.cz>
 <20130802134305.GI25432@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802134305.GI25432@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 03:43:05PM +0200, Michal Hocko wrote:
> On Fri 02-08-13 15:19:01, Michal Hocko wrote:
> [...]
> > mem_cgroup_from_cont can go away now as well. Do you plan to remove it
> > in the series or later on?
> 
> Ohh, it goes in 21/23. Good

Heh, yeah, that one.

Thanks.

-- 
tejun
