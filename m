Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161183Ab3DEJYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:24:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45546 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3DEJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:24:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <515E9831.5060508@jp.fujitsu.com>
Date: Fri, 05 Apr 2013 18:24:01 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 7/7] memcg: kill memcg refcnt
References: <515BF233.6070308@huawei.com> <515BF2E3.4000605@huawei.com>
In-Reply-To: <515BF2E3.4000605@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/03 18:14), Li Zefan wrote:
> Now memcg has the same life cycle as the corresponding cgroup.
> Kill the useless refcnt.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

very very very nice. Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


