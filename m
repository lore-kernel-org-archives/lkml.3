Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbaDVQ75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:59:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbaDVQ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:59:54 -0400
Date: Tue, 22 Apr 2014 18:59:49 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/1] memcg: kill CONFIG_MM_OWNER
Message-ID: <20140422165949.GS29311@dhcp22.suse.cz>
References: <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com>
 <20140416135741.GA9407@redhat.com>
 <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
 <20140418162359.GA4398@redhat.com>
 <20140418172631.GA13323@redhat.com>
 <20140418182444.GB22235@dhcp22.suse.cz>
 <20140418184441.GA26046@redhat.com>
 <20140418191259.GA7413@redhat.com>
 <20140422132355.GO29311@dhcp22.suse.cz>
 <20140422161513.GA6644@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422161513.GA6644@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-04-14 18:15:13, Oleg Nesterov wrote:
> On 04/22, Michal Hocko wrote:
> >
> > On Fri 18-04-14 21:12:59, Oleg Nesterov wrote:
> > >
> > > Seriously what do you think about the patch below? Afaics CONFIG_MM_OWNER
> > > is pointless.
> >
> > Yes, I do not see any reason for a separate config when it has a single
> > user which cannot work without it. So feel free to add my
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> Thanks, included.
> 
> > to the patch with your s-o-b and a simple changelog explaining there the
> > config option didn't have any user outside of MEMCG which cannot work
> > without it.
> 
> OK, please see 1/1.

Good. Thanks!

-- 
Michal Hocko
SUSE Labs
