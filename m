Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3C0PIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:08:52 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:42136 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab3C0PIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:08:50 -0400
Date: Wed, 27 Mar 2013 11:08:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: do not check for do_swap_account in
 mem_cgroup_{read,write,reset}
Message-ID: <20130327150829.GE29052@cmpxchg.org>
References: <1363698415-12737-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363698415-12737-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 02:06:55PM +0100, Michal Hocko wrote:
> since 2d11085e (memcg: do not create memsw files if swap accounting
> is disabled) memsw files are created only if memcg swap accounting is
> enabled so there doesn't make any sense to check for it explicitely in
> mem_cgroup_read, mem_cgroup_write and mem_cgroup_reset.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
