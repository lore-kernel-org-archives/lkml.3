Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936789Ab3DIDDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:03:23 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:23191 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408Ab3DIDDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:03:21 -0400
Message-ID: <516384BC.7040302@huawei.com>
Date: Tue, 9 Apr 2013 11:02:20 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH 5/8] memcg: convert to use cgroup->id
References: <51627DA9.7020507@huawei.com> <51627E33.4090107@huawei.com> <20130408145702.GM17178@dhcp22.suse.cz>
In-Reply-To: <20130408145702.GM17178@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/8 22:57, Michal Hocko wrote:
> On Mon 08-04-13 16:22:11, Li Zefan wrote:
>> This is a preparation to kill css_id.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> This patch depends on the following patch, doesn't it? There is no
> guarantee that id fits into short right now. Not such a big deal but
> would be nicer to have that guarantee for bisectability.
> 

Not necessary, because css_id still prevents us from creating too
many cgroups.

> The patch on its own looks good.
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>


