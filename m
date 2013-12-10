Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3LJIJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:09:41 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37895 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3LJIC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:27 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1386571280.git.vdavydov@parallels.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
Date: Tue, 10 Dec 2013 12:02:26 +0400
Message-ID: <CAA6-i6rSE+PvnvmnE_6jBZvsJ+ZJmX1pSwPBE_JZw-OTotNSxQ@mail.gmail.com>
Subject: Re: [PATCH v13 00/16] kmemcg shrinkers
From: Glauber Costa <glommer@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please note that in contrast to previous versions this patch-set implements
> slab shrinking only when we hit the user memory limit so that kmem allocations
> will still fail if we are below the user memory limit, but close to the kmem
> limit. This is, because the implementation of kmem-only reclaim was rather
> incomplete - we had to fail GFP_NOFS allocations since everything we could
> reclaim was only FS data. I will try to improve this and send in a separate
> patch-set, but currently it is only worthwhile setting the kmem limit to be
> greater than the user mem limit just to enable per-memcg slab accounting and
> reclaim.

That is unfortunate, but it makes sense as a first step.



-- 
E Mare, Libertas
