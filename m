Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbaD2MPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:15:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933447AbaD2MPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:15:34 -0400
Date: Tue, 29 Apr 2014 14:15:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Peter Chiang <pchiang@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] memcg: minor ->mm_owner fix/cleanups
Message-ID: <20140429121531.GF15058@dhcp22.suse.cz>
References: <20140428151926.GA20729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428151926.GA20729@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-04-14 17:19:26, Oleg Nesterov wrote:
> Andrew,
> 
> You applied the last (4th) memcg-kill-config_mm_owner.patch, but other
> patches in this thread were ignored. Hopefully thi is because I sent
> them chaotically.

All of them are queued AFAICS. I do not know where those emails are
archived so i've bounced them to you off-list.

> Let me resend 1-3 in case you missed them. Acked by Michal.
> 
> Oleg.
> 
>  init/main.c   |    1 -
>  kernel/exit.c |   18 +++++++++++-------
>  2 files changed, 11 insertions(+), 8 deletions(-)
> 

-- 
Michal Hocko
SUSE Labs
