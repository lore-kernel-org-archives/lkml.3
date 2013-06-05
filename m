Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3FEI64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:58:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33941 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3FEI6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:58:53 -0400
Date: Wed, 5 Jun 2013 01:58:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch -v4 4/8] memcg: enhance memcg iterator to support
 predicates
Message-ID: <20130605085849.GB7990@mtj.dyndns.org>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <1370254735-13012-5-git-send-email-mhocko@suse.cz>
 <20130604010737.GF29989@mtj.dyndns.org>
 <20130604134523.GH31242@dhcp22.suse.cz>
 <20130604193619.GA14916@htj.dyndns.org>
 <20130604204807.GA13231@dhcp22.suse.cz>
 <20130604205426.GI14916@htj.dyndns.org>
 <20130605073728.GC15997@dhcp22.suse.cz>
 <20130605080545.GF7303@mtj.dyndns.org>
 <20130605085239.GF15997@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605085239.GF15997@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Wed, Jun 05, 2013 at 10:52:39AM +0200, Michal Hocko wrote:
> > One of the core jobs of being a maintainer is ensuring the code stays
> > in readable and maintainable state.
> 
> As you might know I am playing the maintainer role for around year and a
> half and there were many improvemtns merged since then (and some faults
> as well of course).
> There is a lot of space for improvements and I work at areas as time
> permits focusing more at reviews for other people are willing to do.

I see.  Yeah, maybe I was attributing too many things to you.  Sorry
about that.

> [...]
> 
> Please stop distracting from the main purpose of this discussion with
> side tracks and personal things.

I'm not really trying to distract you.  I suppose my points are.

* Let's please pay more attention to each change which goes in.

* Let's prioritize cleanups over new features because, whatever the
  history, memcg needs quite some cleanups.

I really don't have personal vandetta against you.  I'm mostly just
very frustrated about memcg.  Maybe you're too.

Anyways, so you aren't gonna try the skipping thing?

Thanks.

-- 
tejun
