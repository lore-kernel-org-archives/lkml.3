Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaLRQ1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:27:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaLRQ1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:27:21 -0500
Date: Thu, 18 Dec 2014 17:27:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/4] OOM vs PM freezer fixes
Message-ID: <20141218162718.GE832@dhcp22.suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
 <20141207100953.GC15892@dhcp22.suse.cz>
 <20141207135551.GA19034@htj.dyndns.org>
 <20141207190026.GB29065@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141207190026.GB29065@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 07-12-14 20:00:26, Michal Hocko wrote:
> On Sun 07-12-14 08:55:51, Tejun Heo wrote:
> > On Sun, Dec 07, 2014 at 11:09:53AM +0100, Michal Hocko wrote:
> > > this is another attempt to address OOM vs. PM interaction. More
> > > about the issue is described in the last patch. The other 4 patches
> > > are just clean ups. This is based on top of 3.18-rc3 + Johannes'
> > > http://marc.info/?l=linux-kernel&m=141779091114777 which is not in the
> > > Andrew's tree yet but I wanted to prevent from later merge conflicts.
> > 
> > When the patches are based on a custom tree, it's often a good idea to
> > create a git branch of the patches to help reviewing.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git to-review/make-oom-vs-pm-freezing-more-robust-2

Are there any other concerns? Should I just resubmit (after rc1)?
-- 
Michal Hocko
SUSE Labs
