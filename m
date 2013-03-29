Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3C2IXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 04:23:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab3C2IXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 04:23:00 -0400
Date: Fri, 29 Mar 2013 09:22:57 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd
 reclaims at each priority
Message-ID: <20130329082257.GB21227@dhcp22.suse.cz>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-2-git-send-email-mgorman@suse.de>
 <20130325090758.GO2154@dhcp22.suse.cz>
 <51501545.50908@suse.cz>
 <5154C4B6.102@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5154C4B6.102@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28-03-13 23:31:18, Jiri Slaby wrote:
> On 03/25/2013 10:13 AM, Jiri Slaby wrote:
> > BTW I very pray this will fix also the issue I have when I run ltp tests
> > (highly I/O intensive, esp. `growfiles') in a VM while playing a movie
> > on the host resulting in a stuttered playback ;).
> 
> No, this is still terrible. I was now updating a kernel in a VM and had
> problems to even move with cursor.

:/

> There was still 1.2G used by I/O cache.

Could you collect /proc/zoneinfo and /proc/vmstat (say in 1 or 2s
intervals)?
-- 
Michal Hocko
SUSE Labs
