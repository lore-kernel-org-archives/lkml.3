Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbaEUFvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:51:20 -0400
Received: from fgwmail3.fujitsu.co.jp ([164.71.1.134]:35542 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbaEUFvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:51:18 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2014 01:51:18 EDT
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <537C3CAF.5080204@jp.fujitsu.com>
Date: Wed, 21 May 2014 14:42:07 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
CC: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: clean up MAINTAINERS entries
References: <20140513194958.GD28815@htj.dyndns.org> <20140519203339.GE27506@mtj.dyndns.org>
In-Reply-To: <20140519203339.GE27506@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/20 5:33), Tejun Heo wrote:
> On Tue, May 13, 2014 at 03:49:58PM -0400, Tejun Heo wrote:
>> There are currently three cgroup related entries in MAINTAINERS.  Make
>> the following updates.
>>
>> * Make the names - both cgroup and cpuset - singular.  We're mixing
>>    singular and plural all over the place for no good reason.
>>
>> * Drop containers@lists.linux-foundation.org from CGROUP.  That list
>>    doesn't have much to do with cgroup per-se.
>>
>> * Add Documentation field to CGROUP.
>>
>> * Drop mm/*cgroup* from CGROUP.  memcg has separate maintainers.
>>
>> * Prefix the controller-specific ones with "CONTROL CGROUP -" and
>>    collect cgroup related entries under the core one.
>>
>> * Add (MEMCG) abbreviation to MEMCG entry.
>>
>> * Drop Balbir Singh and KAMEZAWA Hiroyuki from memcg maintainers.  It
>>    has been quite a while since both actually worked on memcg.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>
> Applied to cgroup/for-3.16.
>
thank you.

-Kame
  


