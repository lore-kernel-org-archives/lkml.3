Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab3CVOhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:37:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410Ab3CVOhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:37:31 -0400
Date: Fri, 22 Mar 2013 14:37:27 +0000
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Damien Wyart <damien.wyart@gmail.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/8] Reduce system disruption due to kswapd
Message-ID: <20130322143727.GA578@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1363525456-10448-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 01:04:06PM +0000, Mel Gorman wrote:
> Kswapd and page reclaim behaviour has been screwy in one way or the other
> for a long time. Very broadly speaking it worked in the far past because
> machines were limited in memory so it did not have that many pages to scan
> and it stalled congestion_wait() frequently to prevent it going completely
> nuts. In recent times it has behaved very unsatisfactorily with some of
> the problems compounded by the removal of stall logic and the introduction
> of transparent hugepage support with high-order reclaims.
> 

With the current set of feedback the series as it currently stands for
me is located here

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-vmscan-limit-reclaim-v2r7

I haven't tested this version myself yet but others might be interested.

-- 
Mel Gorman
SUSE Labs
