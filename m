Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab3GZSpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:45:16 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51054 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3GZSpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:45:14 -0400
Date: Fri, 26 Jul 2013 14:45:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] arch: mm: pass userspace fault flag to generic fault
 handler
Message-ID: <20130726184500.GQ715@cmpxchg.org>
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org>
 <1374791138-15665-4-git-send-email-hannes@cmpxchg.org>
 <20130726131947.GE17761@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726131947.GE17761@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 03:19:47PM +0200, Michal Hocko wrote:
> On Thu 25-07-13 18:25:35, Johannes Weiner wrote:
> > Unlike global OOM handling, memory cgroup code will invoke the OOM
> > killer in any OOM situation because it has no way of telling faults
> > occuring in kernel context - which could be handled more gracefully -
> > from user-triggered faults.
> > 
> > Pass a flag that identifies faults originating in user space from the
> > architecture-specific fault handlers to generic code so that memcg OOM
> > handling can be improved.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Looks good to me but I guess maintainers of the affected archs should be
> CCed

linux-arch is on CC, that should do the trick :)

> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!
