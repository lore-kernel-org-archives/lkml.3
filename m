Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3GQG3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 02:29:06 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20051 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3GQG3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 02:29:05 -0400
Message-ID: <51E638D6.6030004@huawei.com>
Date: Wed, 17 Jul 2013 14:25:26 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kamal Mostafa <kamal@canonical.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <kernel-team@lists.ubuntu.com>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [ 3.8.y.z extended stable ] Patch "memcg, kmem: fix reference
 count handling on the error path" has been added to staging queue
References: <1374015242-28112-1-git-send-email-kamal@canonical.com> <20130716160658.fc30d70b5230aab5b3b3950b@linux-foundation.org> <1374018009.3225.123.camel@fourier> <20130716174548.f34bc75e.akpm@linux-foundation.org>
In-Reply-To: <20130716174548.f34bc75e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/17 8:45, Andrew Morton wrote:
> On Tue, 16 Jul 2013 16:40:09 -0700 Kamal Mostafa <kamal@canonical.com> wrote:
> 
>> On Tue, 2013-07-16 at 16:06 -0700, Andrew Morton wrote:
>>> On Tue, 16 Jul 2013 15:54:02 -0700 Kamal Mostafa <kamal@canonical.com> wrote:
>>>
>>>> This is a note to let you know that I have just added a patch titled
>>>>
>>>>     memcg, kmem: fix reference count handling on the error path
>>>>
>>>> to the linux-3.8.y-queue branch of the 3.8.y.z extended stable tree 
>>>> which can be found at:
>>>
>>> hm, why.
>>
>> Because it said "Cc: <stable@vger.kernel.org> [3.8]", making me think
>> the author specifically wanted it to be applied to 3.8-stable.
> 
> Damn, so it did, sorry.  Your version removed that line.
> 
> I don't know why I did that - afaict problems can only occur when
> kmalloc(GFP_KERNEL) fails, and that's exceedingly unlikely.
> 

I added the stable tag to this and the other patch, because the bugs were
regressions introduced in recent kernels, and Michal sugguest we may want
to backport them (but not in a strong feeling).

But surely the bug is extreamly unlikely, and seems we currently want to
be more strictly on what patches should go into stable, I think it's fine
to drop it from stable.

