Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaEAMzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:55:03 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60055 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaEAMzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:55:01 -0400
Date: Thu, 1 May 2014 08:54:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Jianyu Zhan <nasa4836@gmail.com>, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.com
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Message-ID: <20140501125450.GA23420@cmpxchg.org>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
 <20140422095923.GD29311@dhcp22.suse.cz>
 <20140428150426.GB24807@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428150426.GB24807@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:04:26PM +0200, Michal Hocko wrote:
> On Tue 22-04-14 11:59:23, Michal Hocko wrote:
> > On Sat 19-04-14 07:01:43, Jianyu Zhan wrote:
> > > introduce helper mem_cgroup_zoneinfo_zone(). This will make
> > > mem_cgroup_iter() code more compact.
> > 
> > I dunno. Helpers are usually nice but this one adds more code then it
> > removes. It also doesn't help the generated code.
> > 
> > So I don't see any reason to merge it.
> 
> So should we drop it from mmotm?

Yes, please.

> > > Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> > > ---
> > >  mm/memcontrol.c | 15 +++++++++++----
> > >  1 file changed, 11 insertions(+), 4 deletions(-)

This helper adds no value, but more code and indirection.

Cc'd Andrew - this is about
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch

Thanks!
