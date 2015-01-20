Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbbATObX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:31:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbATObV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:31:21 -0500
Date: Tue, 20 Jan 2015 15:31:19 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - high reclaim
Message-ID: <20150120143119.GK25342@dhcp22.suse.cz>
References: <1421508079-29293-1-git-send-email-hannes@cmpxchg.org>
 <20150120132519.GH25342@dhcp22.suse.cz>
 <20150120141628.GA11181@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120141628.GA11181@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-01-15 09:16:28, Johannes Weiner wrote:
> On Tue, Jan 20, 2015 at 02:25:19PM +0100, Michal Hocko wrote:
[...]
> > Is this planned to be folded into the original patch or go on its own. I
> > am OK with both ways, maybe having it separate would be better from
> > documentation POV.
> 
> I submitted them to be folded in.  Which aspect would you like to see
> documented?

That the excess target reclaim has been attempted and changed with a
patch which explains why. So this was kind of "git log as a
documentation" thing.

-- 
Michal Hocko
SUSE Labs
