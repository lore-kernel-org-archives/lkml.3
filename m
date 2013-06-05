Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab3FEXG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:06:59 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:36896 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab3FEXG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:06:58 -0400
Date: Wed, 5 Jun 2013 16:06:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcontrol: factor out reclaim iterator loading
 and updating
Message-ID: <20130605230651.GO10693@mtj.dyndns.org>
References: <1370472826-29959-1-git-send-email-hannes@cmpxchg.org>
 <1370472826-29959-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370472826-29959-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 06:53:46PM -0400, Johannes Weiner wrote:
> mem_cgroup_iter() is too hard to follow.  Factor out the lockless
> reclaim iterator loading and updating so it's easier to follow the big
> picture.
> 
> Also document the iterator invalidation mechanism a bit more
> extensively.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
