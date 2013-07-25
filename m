Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3GYBKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:10:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:53824 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3GYBKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:10:16 -0400
Message-ID: <51F07AAB.2040607@huawei.com>
Date: Thu, 25 Jul 2013 09:08:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/8] cgroup: convert cgroup_ida to cgroup_idr
References: <51EFA554.6080801@huawei.com> <51EFA570.5020907@huawei.com> <20130724140702.GD2540@dhcp22.suse.cz>
In-Reply-To: <20130724140702.GD2540@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/24 22:07, Michal Hocko wrote:
> On Wed 24-07-13 17:59:12, Li Zefan wrote:
>> This enables us to lookup a cgroup by its id.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks for the review! I'll wait a couple of days for other comments,
and then update the patchset.

