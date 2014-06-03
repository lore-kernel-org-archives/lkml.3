Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaFCLKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:10:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaFCLKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:10:01 -0400
Date: Tue, 3 Jun 2014 13:09:59 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
Message-ID: <20140603110959.GE1321@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <20140528121023.GA10735@dhcp22.suse.cz>
 <20140528134905.GF2878@cmpxchg.org>
 <20140528142144.GL9895@dhcp22.suse.cz>
 <20140528152854.GG2878@cmpxchg.org>
 <xr93ioopyj1y.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xr93ioopyj1y.fsf@gthelen.mtv.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28-05-14 09:17:13, Greg Thelen wrote:
[...]
> My 2c...  The following works for my use cases:
> 1) introduce memory.low_limit_in_bytes (default=0 thus no default change
>    from older kernels)
> 2) interested users will set low_limit_in_bytes to non-zero value.
>    Memory protected by low limit should be as migratable/reclaimable as
>    mlock memory.  If a zone full of mlock memory causes oom kills, then
>    so should the low limit.

Would fallback mode in overcommit or the corner case situation break
your usecase?

-- 
Michal Hocko
SUSE Labs
