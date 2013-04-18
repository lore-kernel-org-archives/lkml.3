Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936380Ab3DRQp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:45:29 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43401 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132Ab3DRQpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:45:24 -0400
Date: Thu, 18 Apr 2013 09:44:24 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        dormando <dormando@rydia.net>, Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] mm: vmscan: Check if kswapd should writepage once
 per pgdat scan
Message-ID: <20130418164424.GK2018@cmpxchg.org>
References: <1365710278-6807-1-git-send-email-mgorman@suse.de>
 <1365710278-6807-10-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365710278-6807-10-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:57:57PM +0100, Mel Gorman wrote:
> Currently kswapd checks if it should start writepage as it shrinks
> each zone without taking into consideration if the zone is balanced or
> not. This is not wrong as such but it does not make much sense either.
> This patch checks once per pgdat scan if kswapd should be writing pages.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
