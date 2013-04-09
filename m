Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935921Ab3DID77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:59:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45355 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934846Ab3DID76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:59:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <5163922A.9050404@jp.fujitsu.com>
Date: Tue, 09 Apr 2013 12:59:38 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/8] memcg: convert to use cgroup_from_id()
References: <51627DA9.7020507@huawei.com> <51627E09.5010605@huawei.com>
In-Reply-To: <51627E09.5010605@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/08 17:21), Li Zefan wrote:
> This is a preparation to kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>   mm/memcontrol.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: KAMEZAWA Hiroyoku <kamezawa.hiroyu@jp.fujitsu.com>


