Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3LJIE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:04:29 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39868 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3LJIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:04:23 -0500
MIME-Version: 1.0
In-Reply-To: <efacba489a23b3a87321a02828ed1a5094e5c490.1386571280.git.vdavydov@parallels.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<efacba489a23b3a87321a02828ed1a5094e5c490.1386571280.git.vdavydov@parallels.com>
Date: Tue, 10 Dec 2013 12:04:23 +0400
Message-ID: <CAA6-i6oESDwswkmz9hUT7=v8AE4z4GeTqwqrMzxOyTUtanLB-A@mail.gmail.com>
Subject: Re: [PATCH v13 04/16] memcg: move memcg_caches_array_size() function
From: Glauber Costa <glommer@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 12:05 PM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> I need to move this up a bit, and I am doing in a separate patch just to
> reduce churn in the patch that needs it.
>
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Glauber Costa <glommer@openvz.org>
