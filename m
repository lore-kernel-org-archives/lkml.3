Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbbATOQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:16:39 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:48621 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbbATOQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:16:37 -0500
Date: Tue, 20 Jan 2015 09:16:28 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - high reclaim
Message-ID: <20150120141628.GA11181@phnom.home.cmpxchg.org>
References: <1421508079-29293-1-git-send-email-hannes@cmpxchg.org>
 <20150120132519.GH25342@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120132519.GH25342@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 02:25:19PM +0100, Michal Hocko wrote:
> On Sat 17-01-15 10:21:19, Johannes Weiner wrote:
> > High limit reclaim can currently overscan in proportion to how many
> > charges are happening concurrently.  Tone it down such that charges
> > don't target the entire high-boundary excess, but instead only the
> > pages they charged themselves when excess is detected.
> > 
> > Reported-by: Michal Hocko <mhocko@suse.cz>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> I certainly agree with this approach.
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> Is this planned to be folded into the original patch or go on its own. I
> am OK with both ways, maybe having it separate would be better from
> documentation POV.

I submitted them to be folded in.  Which aspect would you like to see
documented?
