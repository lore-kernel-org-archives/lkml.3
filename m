Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab3GCP2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:28:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab3GCP22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:28:28 -0400
Date: Wed, 3 Jul 2013 17:28:24 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [RFC PATCH 0/5] Support multiple pages allocation
Message-ID: <20130703152824.GB30267@dhcp22.suse.cz>
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-07-13 17:34:15, Joonsoo Kim wrote:
[...]
> For one page allocation at once, this patchset makes allocator slower than
> before (-5%). 

Slowing down the most used path is a no-go. Where does this slow down
come from?

[...]
-- 
Michal Hocko
SUSE Labs
