Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3LQNOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:14:24 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:54361 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3LQNOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:14:20 -0500
Date: Tue, 17 Dec 2013 08:14:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Message-ID: <20131217131415.GG29989@htj.dyndns.org>
References: <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216163530.GH32509@htj.dyndns.org>
 <20131216171937.GG26797@dhcp22.suse.cz>
 <20131216172143.GJ32509@htj.dyndns.org>
 <alpine.LNX.2.00.1312161718001.2037@eggly.anvils>
 <52AFC163.5010507@huawei.com>
 <alpine.LNX.2.00.1312162300410.16426@eggly.anvils>
 <20131217131119.GD28991@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217131119.GD28991@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 02:11:19PM +0100, Michal Hocko wrote:
> And sorry for distracting you from the css based approach. I have
> totally misinterpreted the comment above idr_remove.

Heh, you actually interpreted it correctly.  I was the one confused
when moving the id to cgroup.  I should have just converted css_id to
idr based per-subsys id in the first place.  Sorry about that. :)

-- 
tejun
