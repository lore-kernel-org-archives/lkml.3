Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaBDQOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:14:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaBDQOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:14:51 -0500
Date: Tue, 4 Feb 2014 17:14:50 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 3/3] Kconfig: organize memory-related config options
Message-ID: <20140204161450.GP4890@dhcp22.suse.cz>
References: <20140131172443.2EDC06E7@viggo.jf.intel.com>
 <20140131172448.3376826D@viggo.jf.intel.com>
 <52F10EFC.9090901@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F10EFC.9090901@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-02-14 08:02:04, Dave Hansen wrote:
> I'm sending this through the kbuild maintainer (Michal Marek), and he

Wrong Michal ;) CCed now.

> asked that I collect a few acks from some mm folks.  I'm ccing the folks
> who put some of these option in there, or touched them recently.  A
> friendly ack or two would be appreciated.
> 
> On 01/31/2014 09:24 AM, Dave Hansen wrote:
> > This continues in a series of patches to clean up the
> > configuration menus.  I believe they've become really hard to
> > navigate and there are some simple things we can do to make
> > things easier to find.
> > 
> > This creates a "Memory Options" menu and moves some things like
> > swap and slab configuration under them.  It also moves SLUB_DEBUG
> > to the debugging menu.
> > 
> > After this patch, the menu has the following options:
> > 
> >   [ ] Memory placement aware NUMA scheduler
> >   [*] Enable VM event counters for /proc/vmstat
> >   [ ] Disable heap randomization
> >   [*] Support for paging of anonymous memory (swap)
> >       Choose SLAB allocator (SLUB (Unqueued Allocator))
> >   [*] SLUB per cpu partial cache
> >   [*] SLUB: attempt to use double-cmpxchg operations
> 
> 
> 

-- 
Michal Hocko
SUSE Labs
