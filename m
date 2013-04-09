Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615Ab3DIDas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:30:48 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51090 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3DIDar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:30:47 -0400
Message-ID: <51638B2B.4010305@huawei.com>
Date: Tue, 9 Apr 2013 11:29:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH 1/8] cgroup: implement cgroup_is_ancestor()
References: <51627DA9.7020507@huawei.com> <51627DBB.5050005@huawei.com> <51638947.9060303@jp.fujitsu.com>
In-Reply-To: <51638947.9060303@jp.fujitsu.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/9 11:21, Kamezawa Hiroyuki wrote:
> (2013/04/08 17:20), Li Zefan wrote:
>> This will be used as a replacement for css_is_ancestor().
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Hmm....but do we need "depth" ?
> 

which was removed in Tejun's
"[PATCHSET] perf, cgroup: implement hierarchy support for perf_event controller"

