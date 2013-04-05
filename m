Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161509Ab3DEFDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:03:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37124 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3DEFDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:03:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <515E5AAB.2080503@jp.fujitsu.com>
Date: Fri, 05 Apr 2013 14:01:31 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 1/7] memcg: use css_get in sock_update_memcg()
References: <515BF233.6070308@huawei.com> <515BF249.50607@huawei.com>
In-Reply-To: <515BF249.50607@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/03 18:11), Li Zefan wrote:
> Use css_get/css_put instead of mem_cgroup_get/put.
> 
> Note, if at the same time someone is moving @current to a different
> cgroup and removing the old cgroup, css_tryget() may return false,
> and sock->sk_cgrp won't be initialized.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


