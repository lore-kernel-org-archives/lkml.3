Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3EPNyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:54:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab3EPNyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:54:31 -0400
Date: Thu, 16 May 2013 15:54:28 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Reduce system disruption due to kswapd V4
Message-ID: <20130516135428.GG13848@dhcp22.suse.cz>
References: <1368432760-21573-1-git-send-email-mgorman@suse.de>
 <20130515133748.5db2c6fb61c72ec61381d941@linux-foundation.org>
 <20130516103344.GF11497@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516103344.GF11497@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-05-13 11:33:45, Mel Gorman wrote:
[...]
> swapin in this case is an indication as to whether we are swap trashing.
> 	The closer the swapin/swapout ratio is to 0, the worse the

I guess you meant the ratio is closer to 1 not zero.
-- 
Michal Hocko
SUSE Labs
