Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3BESQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:16:28 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39206 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab3BESQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:16:25 -0500
Date: Tue, 5 Feb 2013 13:16:17 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 3/3] memcg: cleanup mem_cgroup_init comment
Message-ID: <20130205181617.GC993@cmpxchg.org>
References: <1360081441-1960-1-git-send-email-mhocko@suse.cz>
 <1360081441-1960-4-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360081441-1960-4-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 05:24:01PM +0100, Michal Hocko wrote:
> We should encourage all memcg controller initialization independent on
> a specific mem_cgroup to be done here rather than exploit css_alloc
> callback and assume that nothing happens before root cgroup is created.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

It seems a little strange to document that the subsystem init function
should be used for initializing the subsystem.  But your new comment
is better than the old comment :-)

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
