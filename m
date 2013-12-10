Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3LJIKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:10:39 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37029 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3LJIKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:10:34 -0500
MIME-Version: 1.0
In-Reply-To: <71c7c5bbcad2e29f81eaf9eaad36c120815125c8.1386571280.git.vdavydov@parallels.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<71c7c5bbcad2e29f81eaf9eaad36c120815125c8.1386571280.git.vdavydov@parallels.com>
Date: Tue, 10 Dec 2013 12:10:34 +0400
Message-ID: <CAA6-i6oO71Ja3z4dAsawTmsNm_FkzmU-LWvq70X+X9JTMDSSiA@mail.gmail.com>
Subject: Re: [PATCH v13 05/16] vmscan: move call to shrink_slab() to shrink_zones()
From: Glauber Costa <glommer@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 12:05 PM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> This reduces the indentation level of do_try_to_free_pages() and removes
> extra loop over all eligible zones counting the number of on-LRU pages.
>

Looks correct to me.
