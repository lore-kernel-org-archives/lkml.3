Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaDQBnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 21:43:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:17659 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaDQBno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 21:43:44 -0400
Message-ID: <534F3139.5010104@huawei.com>
Date: Thu, 17 Apr 2014 09:41:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Rohit Jnagal <jnagal@google.com>,
        Brandon Philips <brandon.philips@coreos.com>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: add documentation about unified
 hierarchy
References: <20140414220917.GD1863@htj.dyndns.org> <534DB46D.7090207@infradead.org> <20140416135120.GI30990@htj.dyndns.org> <534EE512.5090905@infradead.org>
In-Reply-To: <534EE512.5090905@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/17 4:16, Randy Dunlap wrote:
> On 04/16/2014 06:51 AM, Tejun Heo wrote:
>> Hello,
>>
>> On Tue, Apr 15, 2014 at 03:36:29PM -0700, Randy Dunlap wrote:
>>>> +depending on the specific controller.  IOW, hierarchy may be collapsed
>>>
>>> please spell out IOW
>>
>> Updated, but is this really necessary?
> 
> It depends on who your audience is.  I probably think that the audience
> is larger than you think it is.
> 

Yeah, I had to google it. :)

