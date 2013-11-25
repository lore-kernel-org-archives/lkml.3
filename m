Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3KYRlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:41:46 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:56504 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab3KYRlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:41:42 -0500
Date: Mon, 25 Nov 2013 12:41:35 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, glommer@openvz.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH v11 00/15] kmemcg shrinkers
Message-ID: <20131125174135.GE22729@cmpxchg.org>
References: <cover.1385377616.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1385377616.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran out of steam reviewing these because there were too many things
that should be changed in the first couple patches.

I realize this is frustrating to see these type of complaints in v11
of a patch series, but the review bandwidth was simply exceeded back
when Glauber submitted this along with the kmem accounting patches.  A
lot of the kmemcg commits themselves don't even have review tags or
acks, but it all got merged anyway, and the author has moved on to
different projects...

Too much stuff slips past the only two people that have more than one
usecase on their agenda and are willing to maintain this code base -
which is in desparate need of rework and pushback against even more
drive-by feature dumps.  I have repeatedly asked to split the memcg
tree out of the memory tree to better deal with the vastly different
developmental stages of memcg and the rest of the mm code, to no
avail.  So I don't know what to do anymore, but this is not working.

Thoughts?
