Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3H1Pfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:35:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab3H1Pfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:35:50 -0400
Date: Wed, 28 Aug 2013 17:35:48 +0200
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2013-08-27-16-51 uploaded
Message-ID: <20130828153548.GH30126@dhcp22.suse.cz>
References: <20130827235227.99DB95A41D6@corp2gmr1-2.hot.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827235227.99DB95A41D6@corp2gmr1-2.hot.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-08-13 16:52:27, Andrew Morton wrote:
> A git tree which contains the memory management portion of this tree is
> maintained at git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
> by Michal Hocko.  It contains the patches which are between the
> "#NEXT_PATCHES_START mm" and "#NEXT_PATCHES_END" markers, from the series
> file, http://www.ozlabs.org/~akpm/mmotm/series.

I am sorry, but I wasn't online last week and was too busy the last few
weeks so I didn't get to follow up on the last two mmotm updates in
my tree.
The thing is more complicated by many conflicts with the cgroup tree
which seem to be not worth the hassle as the merge window should open
shortly. I will continue with the next major Linus' tree.

Sorry about that.
-- 
Michal Hocko
SUSE Labs
