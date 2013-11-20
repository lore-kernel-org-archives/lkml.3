Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3KTKI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:08:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab3KTKI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:08:56 -0500
Date: Wed, 20 Nov 2013 11:08:54 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org
Subject: Re: [to-be-updated]
 mm-memcg-add-memoryoom_control-notification-for-system-oom.patch removed
 from -mm tree
Message-ID: <20131120100854.GA16531@dhcp22.suse.cz>
References: <528bda46.YlEwHwHdykzBNvfr%akpm@linux-foundation.org>
 <alpine.DEB.2.02.1311200002570.20752@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311200002570.20752@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-11-13 00:05:18, David Rientjes wrote:
> On Tue, 19 Nov 2013, akpm@linux-foundation.org wrote:
> 
> > Subject: [to-be-updated] mm-memcg-add-memoryoom_control-notification-for-system-oom.patch removed from -mm tree
> > To: rientjes@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
> > From: akpm@linux-foundation.org
> > Date: Tue, 19 Nov 2013 13:38:14 -0800
> > 
> > 
> > The patch titled
> >      Subject: mm, memcg: add memory.oom_control notification for system oom
> > has been removed from the -mm tree.  Its filename was
> >      mm-memcg-add-memoryoom_control-notification-for-system-oom.patch
> > 
> > This patch was dropped because an updated version will be merged
> 
> Why is this removed?

I've asked Andrew to drop it for now (you were CCed) and mentioned my
reasons.

> I've laid out my perspective for doing userspace oom handling and this is 
> a vital part for system oom handling.  I know that we are currently 
> discussing alternative proposals but my proposal is by far the most 
> complete and allows the most powerful policies to be implemented in 
> userspace.  I'd prefer if we would keep the patch unless an actual 
> alternative is proposed and agreed upon, we can still discuss alternatives 
> while this in -mm and this patch in no way precludes other mechanisms from 
> being implemented.
> 
> So why remove this?

This is a user interface visible change. I do not want to do it until we
agree on a way to go. I do not see any advantage of having this in -mm
until then. It doesn't need any testing from -next (does it?) and the
code is simple enough to push it later on without troubles if the
memcg.oom_control is considered as a way to go. I do not see any reason
to rush it in now.

-- 
Michal Hocko
SUSE Labs
