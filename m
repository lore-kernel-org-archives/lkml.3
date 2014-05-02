Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaEBL0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:26:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaEBL03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:26:29 -0400
Date: Fri, 2 May 2014 13:26:28 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/9] mm: memcontrol: naturalize charge lifetime
Message-ID: <20140502112627.GG3446@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 16:25:34, Johannes Weiner wrote:
[...]
>  Documentation/cgroups/memcg_test.txt |  160 +--
>  include/linux/memcontrol.h           |   94 +-
>  include/linux/page_cgroup.h          |   43 +-
>  include/linux/swap.h                 |   15 +-
>  kernel/events/uprobes.c              |    1 +
>  mm/filemap.c                         |   13 +-
>  mm/huge_memory.c                     |   51 +-
>  mm/memcontrol.c                      | 1724 ++++++++++++--------------------
>  mm/memory.c                          |   41 +-
>  mm/migrate.c                         |   46 +-
>  mm/rmap.c                            |    6 -
>  mm/shmem.c                           |   28 +-
>  mm/swap.c                            |   22 +
>  mm/swap_state.c                      |    8 +-
>  mm/swapfile.c                        |   21 +-
>  mm/truncate.c                        |    1 -
>  mm/vmscan.c                          |    9 +-
>  mm/zswap.c                           |    2 +-
>  18 files changed, 833 insertions(+), 1452 deletions(-)

Impressive! I will get through the series but it will take some time.

-- 
Michal Hocko
SUSE Labs
