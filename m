Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3EQHQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:16:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab3EQHQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:16:56 -0400
Date: Fri, 17 May 2013 09:16:55 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Message-ID: <20130517071655.GD25158@dhcp22.suse.cz>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-2-git-send-email-mhocko@suse.cz>
 <20130516221200.GF7171@mtj.dyndns.org>
 <20130516221501.GG7171@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516221501.GG7171@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-05-13 15:15:01, Tejun Heo wrote:
> One more thing,
> 
> Given that this is a rather significant behavior change, it probably
> is a good idea to include the the benchmark results from the head
> message?

The testing I have done was on top of the complete series. The last
patch should be irrelevant as I have tested the global reclaim but the
second patch might still influence figures a tiny bit (we still do the
soft limit tree thing). That's why I haven't pushed the numbers here.

I can add that information if people prefer or just ask Andrew to squash
the leader email into the first patch as he tend to do quite often in
other cases as well.
-- 
Michal Hocko
SUSE Labs
