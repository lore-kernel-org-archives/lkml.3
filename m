Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3FEJHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:07:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab3FEJHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:07:42 -0400
Date: Wed, 5 Jun 2013 11:07:39 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
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
Message-ID: <20130605090739.GH15997@dhcp22.suse.cz>
References: <1370254735-13012-5-git-send-email-mhocko@suse.cz>
 <20130604010737.GF29989@mtj.dyndns.org>
 <20130604134523.GH31242@dhcp22.suse.cz>
 <20130604193619.GA14916@htj.dyndns.org>
 <20130604204807.GA13231@dhcp22.suse.cz>
 <20130604205426.GI14916@htj.dyndns.org>
 <20130605073728.GC15997@dhcp22.suse.cz>
 <20130605080545.GF7303@mtj.dyndns.org>
 <20130605085239.GF15997@dhcp22.suse.cz>
 <20130605085849.GB7990@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605085849.GB7990@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-06-13 01:58:49, Tejun Heo wrote:
[...]
> Anyways, so you aren't gonna try the skipping thing?

As I said. I do not consider this a priority for the said reasons (i
will not repeat them).
-- 
Michal Hocko
SUSE Labs
