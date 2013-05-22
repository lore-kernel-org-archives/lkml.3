Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3EVHvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:51:35 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:10582 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3EVHvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:51:31 -0400
Message-ID: <519C78C0.3050204@huawei.com>
Date: Wed, 22 May 2013 15:50:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Vagin <avagin@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>, Andrey Vagin <avagin@openvz.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
References: <1368535118-27369-1-git-send-email-avagin@openvz.org> <20130514160859.GC5055@dhcp22.suse.cz> <20130522074055.GA16207@paralelels.com>
In-Reply-To: <20130522074055.GA16207@paralelels.com>
Content-Type: text/plain; charset="KOI8-R"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/22 15:40, Andrew Vagin wrote:
> On Tue, May 14, 2013 at 06:08:59PM +0200, Michal Hocko wrote:
>>
>> Forgot to add
>> Reviewed-by: Michal Hocko <mhocko@suse.cz>
>> +
>> Cc: stable # 3.9
>>
>> Thanks
> 
> Who usually picks up such patches?

The famous AKPM.

