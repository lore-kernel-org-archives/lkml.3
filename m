Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaJQElZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 00:41:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaJQElX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 00:41:23 -0400
Date: Thu, 16 Oct 2014 21:42:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] mm: memcontrol: continue cache reclaim from
 offlined groups
Message-Id: <20141016214240.ade3712f.akpm@linux-foundation.org>
In-Reply-To: <20141017030221.GA8506@phnom.home.cmpxchg.org>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
	<1413303637-23862-5-git-send-email-hannes@cmpxchg.org>
	<20141015152555.GI23547@dhcp22.suse.cz>
	<20141017030221.GA8506@phnom.home.cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 23:02:21 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Andrew, could you update the changelog in place to have that paragraph
> read
> 
> Since c2931b70a32c ("cgroup: iterate cgroup_subsys_states directly")
> css iterators now also include offlined css, so memcg iterators can be
> changed to include offlined children during reclaim of a group, and
> leftover cache can just stay put.

Done.
