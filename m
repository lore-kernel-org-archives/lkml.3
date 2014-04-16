Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaDPUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:16:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57403 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaDPUQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:16:27 -0400
Message-ID: <534EE512.5090905@infradead.org>
Date: Wed, 16 Apr 2014 13:16:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Rohit Jnagal <jnagal@google.com>,
        Brandon Philips <brandon.philips@coreos.com>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: add documentation about unified
 hierarchy
References: <20140414220917.GD1863@htj.dyndns.org> <534DB46D.7090207@infradead.org> <20140416135120.GI30990@htj.dyndns.org>
In-Reply-To: <20140416135120.GI30990@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 06:51 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 15, 2014 at 03:36:29PM -0700, Randy Dunlap wrote:
>>> +depending on the specific controller.  IOW, hierarchy may be collapsed
>>
>> please spell out IOW
> 
> Updated, but is this really necessary?

It depends on who your audience is.  I probably think that the audience
is larger than you think it is.

>> I would prefer to see CPU instead of cpu (except when it refers to a
>> task or function).
> 
> cpu sometimes refer to the cpu controller.  Will use CPU when it's
> actually referring to the CPU.

OK, thanks.


-- 
~Randy
