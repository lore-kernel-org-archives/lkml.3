Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3C0BQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 21:16:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27849 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3C0BQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 21:16:11 -0400
Message-ID: <51524849.6090603@huawei.com>
Date: Wed, 27 Mar 2013 09:15:53 +0800
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
References: <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514EAC41.5050700@huawei.com> <20130325090629.GN2154@dhcp22.suse.cz> <51515DEE.70105@parallels.com> <20130326084348.GJ2295@dhcp22.suse.cz> <51516410.2000007@parallels.com>
In-Reply-To: <51516410.2000007@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Although correct, it is a bit misleading. It is static in the sense it
> is held by a static variable. But it is acquired by kmalloc...
> 
> In any way, this is a tiny detail.
> 
> FWIW, I am fine with the patch you provided:
> 
> Acked-by: Glauber Costa <glommer@parallels.com>
> 

Michal, could you resend your final patch to Tejun in a new mail thread?
There are quite a few different patches inlined in this thread.

