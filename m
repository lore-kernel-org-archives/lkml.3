Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260Ab3D3RgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:36:18 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:44169 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921Ab3D3RgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:36:15 -0400
Date: Tue, 30 Apr 2013 13:36:07 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, memcg: add rss_huge stat to memory.stat
Message-ID: <20130430173607.GF1229@cmpxchg.org>
References: <alpine.DEB.2.02.1304251440190.27228@chino.kir.corp.google.com>
 <20130426111739.GF31157@dhcp22.suse.cz>
 <alpine.DEB.2.02.1304281432160.5570@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1304291721550.4634@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304291721550.4634@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 05:22:52PM -0700, David Rientjes wrote:
> This exports the amount of anonymous transparent hugepages for each memcg
> via the new "rss_huge" stat in memory.stat.  The units are in bytes.
> 
> This is helpful to determine the hugepage utilization for individual jobs
> on the system in comparison to rss and opportunities where MADV_HUGEPAGE
> may be helpful.
> 
> The amount of anonymous transparent hugepages is also included in "rss"
> for backwards compatibility.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
