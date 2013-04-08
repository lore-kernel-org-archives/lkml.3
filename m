Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936595Ab3DHPvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:51:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44524 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936499Ab3DHPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:51:47 -0400
Date: Mon, 8 Apr 2013 08:51:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 8/8] cgroup: kill css_id
Message-ID: <20130408155142.GF3021@htj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627E8E.1010204@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51627E8E.1010204@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 04:23:42PM +0800, Li Zefan wrote:
> The only user of css_id was memcg, and it has been converted to
> use cgroup->id, so kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Violently-acked-by: Tejun Heo <tj@kernel.org>

Thanks a lot for killing this abomination.

-- 
tejun
