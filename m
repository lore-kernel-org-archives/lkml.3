Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaE1Hqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:46:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51690 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaE1Hqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:46:48 -0400
Message-ID: <53859447.4050001@huawei.com>
Date: Wed, 28 May 2014 15:46:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: clean up MAINTAINERS entries
References: <20140513194958.GD28815@htj.dyndns.org> <20140519203339.GE27506@mtj.dyndns.org>
In-Reply-To: <20140519203339.GE27506@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/20 4:33, Tejun Heo wrote:
> On Tue, May 13, 2014 at 03:49:58PM -0400, Tejun Heo wrote:
>> There are currently three cgroup related entries in MAINTAINERS.  Make
>> the following updates.
>>
>> * Make the names - both cgroup and cpuset - singular.  We're mixing
>>   singular and plural all over the place for no good reason.
>>
>> * Drop containers@lists.linux-foundation.org from CGROUP.  That list
>>   doesn't have much to do with cgroup per-se.
>>
>> * Add Documentation field to CGROUP.
>>
>> * Drop mm/*cgroup* from CGROUP.  memcg has separate maintainers.
>>
>> * Prefix the controller-specific ones with "CONTROL CGROUP -" and
>>   collect cgroup related entries under the core one.
>>
>> * Add (MEMCG) abbreviation to MEMCG entry.
>>
>> * Drop Balbir Singh and KAMEZAWA Hiroyuki from memcg maintainers.  It
>>   has been quite a while since both actually worked on memcg.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Applied to cgroup/for-3.16.
> 

Late ack for the cgroup and cpuset parts.

Don't know why I overlooked this and the debug controller patch...

