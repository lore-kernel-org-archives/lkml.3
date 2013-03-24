Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3CXHfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 03:35:07 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:42279 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab3CXHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 03:35:03 -0400
Message-ID: <514EAC9B.1010706@huawei.com>
Date: Sun, 24 Mar 2013 15:34:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
References: <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514C2754.4080701@parallels.com> <20130322094832.GG31457@dhcp22.suse.cz> <514C2C72.5090402@parallels.com> <20130322100609.GI31457@dhcp22.suse.cz> <514C3193.9010609@parallels.com> <20130322105616.GK31457@dhcp22.suse.cz>
In-Reply-To: <20130322105616.GK31457@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I read the code as lockdep_assert(memcg_cache_mutex), and then later on
>> mutex_lock(&memcg_mutex). But reading again, that was a just an
>> rcu_read_lock(). Good thing it is Friday
>>
>> You guys can add my Acked-by, and thanks again
> 
> Li, are you ok to take the page via your tree?
> 

I don't have a git tree in kernel.org. It's Tejun that picks up
cgroup patches.

