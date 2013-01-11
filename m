Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3AKJG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:06:29 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:61382 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3AKJGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:06:25 -0500
Message-ID: <50EFD5C3.7020406@huawei.com>
Date: Fri, 11 Jan 2013 17:05:07 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <paul@paulmenage.org>, <glommer@parallels.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <peterz@infradead.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] cpuset: decouple cpuset locking from cgroup core,
 take#2
References: <1357248967-24959-1-git-send-email-tj@kernel.org> <50E93554.3070102@huawei.com> <20130107164453.GH3926@htj.dyndns.org> <50EB76DF.5070508@huawei.com> <20130109185724.GP3926@htj.dyndns.org>
In-Reply-To: <20130109185724.GP3926@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/10 2:57, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Jan 08, 2013 at 09:31:11AM +0800, Li Zefan wrote:
>> I don't think Paul's still maintaining cpusets. Normally it's Andrew
>> that picks up cpuset patches. It's fine you route it through cgroup
>> tree.
> 
> Can you please take over the cpuset maintainership then?  I think you
> would be the one most familiar with the code base at this point.
> 

Sure, I'll send a patch to update MAINTAINERS.

