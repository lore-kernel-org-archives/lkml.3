Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923Ab3DDHHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:07:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763907Ab3DDHHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:07:02 -0400
Date: Thu, 4 Apr 2013 09:06:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Message-ID: <20130404070657.GA29911@dhcp22.suse.cz>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz>
 <20130327145727.GD29052@cmpxchg.org>
 <20130327151104.GK16579@dhcp22.suse.cz>
 <51530E1E.3010100@parallels.com>
 <20130327153220.GL16579@dhcp22.suse.cz>
 <20130327173223.GQ16579@dhcp22.suse.cz>
 <20130328074814.GA3018@dhcp22.suse.cz>
 <20130402082648.GB24345@dhcp22.suse.cz>
 <20130403213334.GE3411@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403213334.GE3411@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-04-13 14:33:34, Tejun Heo wrote:
> On Tue, Apr 02, 2013 at 10:26:48AM +0200, Michal Hocko wrote:
> > Tejun,
> > could you take this one please?
> 
> Aye aye, applied to cgroup/for-3.10.

Thanks!
-- 
Michal Hocko
SUSE Labs
