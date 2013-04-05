Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161166Ab3DEJXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:23:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42402 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161121Ab3DEJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:23:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <515E97E1.3070208@jp.fujitsu.com>
Date: Fri, 05 Apr 2013 18:22:41 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 6/7] memcg: don't need to get a reference to the
 parent
References: <515BF233.6070308@huawei.com> <515BF2B1.9060909@huawei.com>
In-Reply-To: <515BF2B1.9060909@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/03 18:13), Li Zefan wrote:
> The cgroup core guarantees it's always safe to access the parent.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


