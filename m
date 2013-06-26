Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3FZSwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:52:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16825 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3FZSwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:52:15 -0400
Message-ID: <51CB3838.10400@oracle.com>
Date: Wed, 26 Jun 2013 14:51:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, LKML <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, trinity@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.11] cgroup: grab cgroup_mutex in drop_parsed_module_refcounts()
References: <51C9D17B.5090208@oracle.com> <20130626010454.GD30407@mtj.dyndns.org> <20130626010521.GE30407@mtj.dyndns.org> <20130626175008.GF4405@mtj.dyndns.org>
In-Reply-To: <20130626175008.GF4405@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 01:50 PM, Tejun Heo wrote:
> On Tue, Jun 25, 2013 at 06:05:21PM -0700, Tejun Heo wrote:
>> This isn't strictly necessary as all subsystems specified in
>> @subsys_mask are guaranteed to be pinned; however, it does spuriously
>> trigger lockdep warning.  Let's grab cgroup_mutex around it.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>
> Applied both patches to cgroup/for-3.11.

FWIW, for both patches,

	Tested-by: Sasha Levin <sasha.levin@oracle.com>


Thanks,
Sasha
