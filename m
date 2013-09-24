Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3IXAcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:32:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26769 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3IXAci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:32:38 -0400
Message-ID: <5240DD83.1070509@huawei.com>
Date: Tue, 24 Sep 2013 08:32:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
References: <524001F8.6070205@huawei.com> <20130923130816.GH30946@htj.dyndns.org> <20130923131215.GI30946@htj.dyndns.org>
In-Reply-To: <20130923131215.GI30946@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/23 21:12, Tejun Heo wrote:
> On Mon, Sep 23, 2013 at 09:08:16AM -0400, Tejun Heo wrote:
>> Hello,
>>
>> On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
>>> The whole patchset has been acked and reviewed by Michal and Tejun.
>>> Could you merge it into mm tree?
>>
>> Ah... I really hoped that this had been merged during -rc1 window.
>> Andrew, would it be okay to carry this series through cgroup tree?  It
>> doesn't really have much to do with mm proper and it's a PITA to have
>> to keep updating css_id code from cgroup side when it's scheduled to
>> go away.  If carried in -mm, it's likely to cause conflicts with
>> ongoing cgroup changes too.

I would love to see this patchset go through cgroup tree. The changes to
memcg is quite small, and as -mm tree is based on -next it won't cause
future conflicts.

> 
> Also, wasn't this already in -mm during the last devel cycle?  ISTR
> conflicts with it in -mm with other cgroup core changes.  Is there any
> specific reason why this wasn't merged during the merge windw?
> 

No, it never went into -mm tree... I guess it's because Andrew was too
busy and overlooked this patchset?

