Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633Ab3GaLtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:49:09 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:42856 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3GaLtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:49:07 -0400
Date: Wed, 31 Jul 2013 07:49:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 8/8] cgroup: kill css_id
Message-ID: <20130731114902.GP2810@htj.dyndns.org>
References: <51F86D69.2030907@huawei.com>
 <51F86DFC.9060301@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F86DFC.9060301@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 09:53:00AM +0800, Li Zefan wrote:
> The only user of css_id was memcg, and it has been convered to use
> cgroup->id, so kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huwei.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Violently-acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
