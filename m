Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaCMRE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:04:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbaCMREZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:04:25 -0400
Date: Thu, 13 Mar 2014 18:04:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2014-03-12-16-04 uploaded
Message-ID: <20140313170423.GI4473@dhcp22.suse.cz>
References: <20140312230510.69CD831C078@corp2gmr1-1.hot.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312230510.69CD831C078@corp2gmr1-1.hot.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-03-14 16:05:10, Andrew Morton wrote:
[...]
> A git tree which contains the memory management portion of this tree is
> maintained at git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
> by Michal Hocko.  It contains the patches which are between the
> "#NEXT_PATCHES_START mm" and "#NEXT_PATCHES_END" markers, from the series
> file, http://www.ozlabs.org/~akpm/mmotm/series

I am sorry but I didn't get to update the last two releases and probably
wont't make the next in this release cycle because I am quite busy with
other stuff and there are too many cross tree conflicts to have this
automated (notably slab and cgroup trees are conflicting a lot). Let's
see whether I can sort it out before traveling to LSF next week
otherwise I will start after getting back (around 12th Apr. after
vacation) with a new release cycle. Sorry about that!
-- 
Michal Hocko
SUSE Labs
