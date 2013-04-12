Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3DLTkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:40:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab3DLTkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:40:10 -0400
Date: Fri, 12 Apr 2013 20:40:04 +0100
From: Mel Gorman <mgorman@suse.de>
To: Zlatko Calusic <zcalusic@bitsync.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        dormando <dormando@rydia.net>, Satoru Moriya <satoru.moriya@hds.com>,
        Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Reduce system disruption due to kswapd V2
Message-ID: <20130412193947.GJ11656@suse.de>
References: <1365505625-9460-1-git-send-email-mgorman@suse.de>
 <51672331.6070605@bitsync.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <51672331.6070605@bitsync.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:55:13PM +0200, Zlatko Calusic wrote:
> On 09.04.2013 13:06, Mel Gorman wrote:
> <SNIP>
>
> - The only slightly negative thing I observed is that with the patch
> applied kswapd burns 10x - 20x more CPU. So instead of about 15
> seconds, it has now spent more than 4 minutes on one particular
> machine with a quite steady load (after about 12 days of uptime).
> Admittedly, that's still nothing too alarming, but...
> 

Would you happen to know what circumstances trigger the higher CPU
usage?

> - I like VERY much how you cleaned up the code so it is more
> readable now. I'd like to see it in the Linus tree as soon as
> possible. Very good job there!
> 

Thanks.

-- 
Mel Gorman
SUSE Labs
