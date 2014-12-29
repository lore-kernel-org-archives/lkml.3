Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaL2InO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 03:43:14 -0500
Received: from mx2.parallels.com ([199.115.105.18]:48117 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaL2InM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:43:12 -0500
Date: Mon, 29 Dec 2014 11:42:59 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: memcontrol: switch soft limit default back to
 infinity
Message-ID: <20141229084259.GA9984@esperanza>
References: <1419792468-9278-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1419792468-9278-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 01:47:48PM -0500, Johannes Weiner wrote:
> 3e32cb2e0a12 ("mm: memcontrol: lockless page counters") accidentally
> switched the soft limit default from infinity to zero, which turns all
> memcgs with even a single page into soft limit excessors and engages
> soft limit reclaim on all of them during global memory pressure.  This
> makes global reclaim generally more aggressive, but also inverts the
> meaning of existing soft limit configurations where unset soft limits
> are usually more generous than set ones.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Overlooked that :-/

Acked-by: Vladimir Davydov <vdavydov@parallels.com>
