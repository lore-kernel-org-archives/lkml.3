Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaAPJc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:32:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbaAPJcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:32:23 -0500
Date: Thu, 16 Jan 2014 10:32:20 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Message-ID: <20140116093220.GC28157@dhcp22.suse.cz>
References: <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com>
 <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
 <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org>
 <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
 <20140110221432.GD6963@cmpxchg.org>
 <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com>
 <20140115143449.GN8782@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401151319580.10727@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401151319580.10727@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-01-14 13:23:10, David Rientjes wrote:
> On Wed, 15 Jan 2014, Michal Hocko wrote:
[...]
> > Which depends on yours only to revert your part. I plan to repost it but
> > that still doesn't mean it will get merged because Johannes still has
> > some argumnets against. I would like to start the discussion again
> > because now we are so deep in circles that it is hard to come up with a
> > reasonable outcome. It is still hard to e.g. agree on an actual fix
> > for a real problem https://lkml.org/lkml/2013/12/12/129.
> > 
> 
> This is concerning because it's merged in -mm without being tested by Eric 
> and is marked for stable while violating the stable kernel rules criteria.

Are you questioning the patch fixes the described issue?

Please note that the exit_robust_list and PF_EXITING as a culprit has
been identified by Eric. Of course I would prefer if it was tested by
anybody who can reproduce it.
-- 
Michal Hocko
SUSE Labs
