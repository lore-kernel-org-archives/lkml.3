Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaAJIaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:30:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaAJIa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:30:27 -0500
Date: Fri, 10 Jan 2014 09:30:25 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Message-ID: <20140110083025.GE9437@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com>
 <20131217162342.GG28991@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
 <20131218200434.GA4161@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz>
 <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com>
 <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 09-01-14 16:01:15, David Rientjes wrote:
> On Thu, 9 Jan 2014, Andrew Morton wrote:
> 
> > > I'm not sure why this was dropped since it's vitally needed for any sane 
> > > userspace oom handler to be effective.
> > 
> > It was dropped because the other memcg developers disagreed with it.
> > 
> 
> It was acked-by Michal.

I have already explained why I have acked it. I will not repeat
it here again. I have also proposed an alternative solution
(https://lkml.org/lkml/2013/12/12/174) which IMO is more viable because
it handles both user/kernel memcg OOM consistently. This patch still has
to be discussed because of other Johannes concerns. I plan to repost it
in a near future.

-- 
Michal Hocko
SUSE Labs
