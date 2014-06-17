Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613AbaFQQgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:36:22 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51874 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965381AbaFQQgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:36:18 -0400
Date: Tue, 17 Jun 2014 18:36:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/12] mm: memcontrol: naturalize charge lifetime v3
Message-ID: <20140617163615.GD9572@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16-06-14 15:54:20, Johannes Weiner wrote:
> Hi,
> 
> this is v3 of the memcg charge naturalization series.  Changes since
> v2 include:
> 
> o make THP charges use __GFP_NORETRY to prevent excessive reclaim (Michal)
> o simplify move precharging while in the area
> o add acks & rebase to v3.16-rc1

I still didn't get to the last two patches and they need a more
throughout review. The rest is good and nice on its own and maybe it
would be easier if those go in first.

I would like to get to the last two ASAP but this is heavier and I am
quite swamped by other small tasks last weeks so I do not want to delay
the whole series.

What do you think?
-- 
Michal Hocko
SUSE Labs
