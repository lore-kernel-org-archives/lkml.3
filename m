Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaL2Iyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 03:54:49 -0500
Received: from mx2.parallels.com ([199.115.105.18]:57586 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaL2Iyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:54:47 -0500
Date: Mon, 29 Dec 2014 11:54:35 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 2/2] memcg: add memory and swap knobs to the default
 cgroup hierarchy
Message-ID: <20141229085435.GC9984@esperanza>
References: <dd99dc0de2ce6fd9aa18b25851819b71a58dca7d.1419782051.git.vdavydov@parallels.com>
 <9aeed65ee700e81abde90c20570415a40acb36e2.1419782051.git.vdavydov@parallels.com>
 <20141228203023.GB9385@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141228203023.GB9385@phnom.home.cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 03:30:23PM -0500, Johannes Weiner wrote:
> As such, my proposals would be:
> 
>   memory.low:        the expected lower end of the workload size
>   memory.high:       the expected upper end
>   memory.max:        the absolute OOM-enforced maximum size
>   memory.current:    the current size
> 
> And then, in the same vein:
> 
>   swap.max
>   swap.current
> 
> These names are short, but they should be unambiguous and descriptive
> in their context, and users will have to consult the documentation on
> how to configure this stuff anyway.

To me, memory.max resembles memory.max_usage_in_bytes from the old
interface, which is confusing. However, if we forget about the old
interface, the new names look fine.

Thanks,
Vladimir
