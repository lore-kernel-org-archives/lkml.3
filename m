Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3GYBAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:00:21 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:51420 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3GYBAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:00:19 -0400
Message-ID: <51F07863.2070705@huawei.com>
Date: Thu, 25 Jul 2013 08:59:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/8] memcg, cgroup: kill css_id
References: <51EFA554.6080801@huawei.com> <20130724143214.GL2540@dhcp22.suse.cz>
In-Reply-To: <20130724143214.GL2540@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/24 22:32, Michal Hocko wrote:
> On Wed 24-07-13 17:58:44, Li Zefan wrote:
>> This patchset converts memcg to use cgroup->id, and then we can remove
>> cgroup css_id.
>>
>> As we've removed memcg's own refcnt, converting memcg to use cgroup->id
>> is very straight-forward.
>>
>> The patchset is based on Tejun's cgroup tree.
> 
> Does it depend on any particular patches? I am asking because I would
> need to cherry pick those and apply them into my -mm git tree before
> these.
> 

Nope, but you should see a few but small conflicts if you apply them to
your git tree.

