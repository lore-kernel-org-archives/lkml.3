Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161563Ab3FUPJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:09:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161543Ab3FUPJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:09:08 -0400
Date: Fri, 21 Jun 2013 17:09:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v5] Soft limit rework
Message-ID: <20130621150906.GM12424@dhcp22.suse.cz>
References: <1371557387-22434-1-git-send-email-mhocko@suse.cz>
 <20130620111206.GA14809@suse.de>
 <20130621140627.GI12424@dhcp22.suse.cz>
 <20130621140938.GJ12424@dhcp22.suse.cz>
 <20130621150430.GL12424@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621150430.GL12424@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-06-13 17:04:30, Michal Hocko wrote:
> On Fri 21-06-13 16:09:38, Michal Hocko wrote:
> > On Fri 21-06-13 16:06:27, Michal Hocko wrote:
> > [...]
> > > > Can you try this monolithic patch please?
> > > 
> > > Wow, this looks much better!
> > 
> > Damn it! Scratch that. I have made a mistake in configuration so this
> > all has been 0-no-limit in fact. Sorry about that. It's only now that
> > I've noticed that so I am retesting. Hopefully it will be done before I
> > leave today. I will post it on Monday otherwise.
> 
> And for real now and it is still Wow!

And I am total idiot. The machine was not booted with mem=1G so the
figures are completely useless.

It is soooo Friday. I will start everything again on Monday with a clean
head.

Sorry about all the noise.
-- 
Michal Hocko
SUSE Labs
