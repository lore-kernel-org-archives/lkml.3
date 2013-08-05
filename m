Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3HEQBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:01:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab3HEQBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:01:11 -0400
Date: Mon, 5 Aug 2013 18:01:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Message-ID: <20130805160107.GM10146@dhcp22.suse.cz>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375632446-2581-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 04-08-13 12:07:21, Tejun Heo wrote:
> Hello,

Hi Tejun,

> Like many other things in cgroup, cgroup_event is way too flexible and
> complex - it strives to provide completely flexible event monitoring
> facility in cgroup proper which allows any number of users to monitor
> custom events.  This is overboard, to say the least,

Could you be more specific about what is so "overboard" about this
interface? I am not familiar with internals much, so I cannot judge the
complexity part, but I thought that eventfd was intended for this kind
of kernel->userspace notifications.

> and I strongly think that cgroup should not any new usages of this
> facility and preferably deprecate the existing usages if at all
> possible.

So you think that vmpressure, oom notification or thresholds are
an abuse of this interface? What would you consider a reasonable
replacement for those notifications?  Or do you think that controller
shouldn't be signaling any conditions to the userspace at all?

[...]
-- 
Michal Hocko
SUSE Labs
