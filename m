Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3G3BIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:08:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:55393 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3G3BIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:08:52 -0400
Message-ID: <51F711FE.3040006@huawei.com>
Date: Tue, 30 Jul 2013 09:08:14 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH v3 2/8] cgroup: document how cgroup IDs are assigned
References: <51F614B2.6010503@huawei.com> <51F614D4.6000703@huawei.com> <20130729182632.GC26076@mtj.dyndns.org>
In-Reply-To: <20130729182632.GC26076@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/30 2:26, Tejun Heo wrote:
> On Mon, Jul 29, 2013 at 03:08:04PM +0800, Li Zefan wrote:
>> As cgroup id has been used in netprio cgroup and will be used in memcg,
>> it's important to make it clear how a cgroup id is allocated.
>>
>> For example, in netprio cgroup, the id is used as index of anarray.
>>
>> Signed-off-by: Li Zefan <lizefan@huwei.com>
>> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 
> We can merge this into the first patch?
> 

The first patch just changes ida to idr, it doesn't change how IDs are
allocated, so I prefer make this a standalone patch.

