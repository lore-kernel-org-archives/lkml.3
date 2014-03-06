Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaCFU7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:59:18 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:63660 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFU7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:59:16 -0500
Date: Thu, 6 Mar 2014 15:59:11 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 00/11] userspace out of memory handling
Message-ID: <20140306205911.GG14033@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <20140306204923.GF14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 12:55:43PM -0800, David Rientjes wrote:
> > ISTR the conclusion last time was nack on the whole approach.  What
> > changed between then and now?  I can't detect any fundamental changes
> > from the description.
> > 
> 
> This includes system oom handling alongside memcg oom handling.  If you 
> have specific objections, please let us know, thanks!

Umm, that wasn't the bulk of objection, was it?  We were discussion
the whole premise of userland oom handling and the conclusion, at
best, was that you couldn't show that it was actually necessary and
most other people disliked the idea.  Just changing a part of it and
resubmitting doesn't really change the whole situation.  If you want
to continue the discussion on the basic approach, please do continue
that on the original thread so that we don't lose the context.  I'm
gonna nack the respective patches so that they don't get picked up by
accident for now.

Thanks.

-- 
tejun
