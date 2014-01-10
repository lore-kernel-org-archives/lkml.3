Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbaAJVi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:38:59 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:62857 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaAJViy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:38:54 -0500
Date: Fri, 10 Jan 2014 13:38:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20140110083025.GE9437@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1401101335200.21486@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com> <20131217162342.GG28991@dhcp22.suse.cz> <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140110083025.GE9437@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Michal Hocko wrote:

> I have already explained why I have acked it. I will not repeat
> it here again. I have also proposed an alternative solution
> (https://lkml.org/lkml/2013/12/12/174) which IMO is more viable because
> it handles both user/kernel memcg OOM consistently. This patch still has
> to be discussed because of other Johannes concerns. I plan to repost it
> in a near future.
> 

This three ring circus has to end.  Really.

Your patch, which is partially based on my suggestion to move the 
mem_cgroup_oom_notify() and call it from two places to support both 
memory.oom_control == 1 and != 1, is something that I liked as you know.  
It's based on my patch which is now removed from -mm.  So if you want to 
rebase that patch and propose it, that's great, but this is yet another 
occurrence of where important patches have been yanked out just before the 
merge window when the problem they are fixing is real and we depend on 
them.

Please post your rebased patch ASAP for the 3.14 merge window.
