Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbbATPpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:45:07 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:48658 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbbATPpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:45:04 -0500
Date: Tue, 20 Jan 2015 10:44:56 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - high reclaim
Message-ID: <20150120154456.GA7130@phnom.home.cmpxchg.org>
References: <1421508079-29293-1-git-send-email-hannes@cmpxchg.org>
 <20150120132519.GH25342@dhcp22.suse.cz>
 <20150120141628.GA11181@phnom.home.cmpxchg.org>
 <20150120143119.GK25342@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120143119.GK25342@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 03:31:19PM +0100, Michal Hocko wrote:
> On Tue 20-01-15 09:16:28, Johannes Weiner wrote:
> > On Tue, Jan 20, 2015 at 02:25:19PM +0100, Michal Hocko wrote:
> [...]
> > > Is this planned to be folded into the original patch or go on its own. I
> > > am OK with both ways, maybe having it separate would be better from
> > > documentation POV.
> > 
> > I submitted them to be folded in.  Which aspect would you like to see
> > documented?
> 
> That the excess target reclaim has been attempted and changed with a
> patch which explains why. So this was kind of "git log as a
> documentation" thing.

I agreed to soften it because you had reasonable concerns and it was
still strong enough for my tests.  But we hardly "attempted" this
version.  Should this turn out to be too weak for other users in
practice we have to reconsider the stronger approach and actually put
your theory to the test and see if it holds up in practice.  There is
no knowledge to record at this point, we just have speculation and no
real need to push the envelope right now.
