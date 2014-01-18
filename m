Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaARPa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 10:30:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaARPa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 10:30:26 -0500
Message-ID: <52DA9DDB.407@redhat.com>
Date: Sat, 18 Jan 2014 16:29:31 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/6] cgroup: make CONFIG_NET_CLS_CGROUP and CONFIG_NETPRIO_CGROUP
 bool instead of tristate
References: <1389982317-22225-1-git-send-email-tj@kernel.org> <1389982317-22225-2-git-send-email-tj@kernel.org> <52D9D421.6040608@huawei.com> <20140118151006.GF3640@htj.dyndns.org> <52DA9D20.6010301@redhat.com> <20140118152813.GG3640@htj.dyndns.org>
In-Reply-To: <20140118152813.GG3640@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2014 04:28 PM, Tejun Heo wrote:
> On Sat, Jan 18, 2014 at 04:26:24PM +0100, Daniel Borkmann wrote:
>>> Unless there's gonna be another rc, I think it's already a bit too
>>> late for 3.14 anyway.  I'll drop the net_cls part and rebase the
>>> changes on top of rc1 later on.
>>
>> I think that's 1 patch of your series, right?
>
> They overlap.
>
>> I think this one could still go through net-next if you want, that would
>> avoid a merge conflict.
>
> If there's gonna be another rc, I'll prolly just cherry-pick the
> commit from net-next and then rebase the rest on top of it.  If there
> isn't gonna be another rc, I'm just gonna base everything on v3.14-rc1
> which would include the patch from net-next.

Ok, sounds good.

Thanks Tejun.
