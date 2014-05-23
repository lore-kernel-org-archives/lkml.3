Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaEWO3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:29:40 -0400
Received: from mx2.parallels.com ([199.115.105.18]:58760 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaEWO3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:29:39 -0400
Date: Fri, 23 May 2014 18:29:31 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Michal Hocko <mhocko@suse.cz>, <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 7/9] mm: memcontrol: do not acquire page_cgroup lock for
 kmem pages
Message-ID: <20140523142929.GC3147@esperanza>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-8-git-send-email-hannes@cmpxchg.org>
 <20140523133938.GC22135@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140523133938.GC22135@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 03:39:38PM +0200, Michal Hocko wrote:
> I am adding Vladimir to CC
> 
> On Wed 30-04-14 16:25:41, Johannes Weiner wrote:
> > Kmem page charging and uncharging is serialized by means of exclusive
> > access to the page.  Do not take the page_cgroup lock and don't set
> > pc->flags atomically.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vladimir Davydov <vdavydov@parallels.com>
