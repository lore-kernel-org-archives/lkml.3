Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaBDQCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:02:11 -0500
Received: from www.sr71.net ([198.145.64.142]:49974 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbaBDQCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:02:07 -0500
Message-ID: <52F10EFC.9090901@sr71.net>
Date: Tue, 04 Feb 2014 08:02:04 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/3] Kconfig: organize memory-related config options
References: <20140131172443.2EDC06E7@viggo.jf.intel.com> <20140131172448.3376826D@viggo.jf.intel.com>
In-Reply-To: <20140131172448.3376826D@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending this through the kbuild maintainer (Michal Marek), and he
asked that I collect a few acks from some mm folks.  I'm ccing the folks
who put some of these option in there, or touched them recently.  A
friendly ack or two would be appreciated.

On 01/31/2014 09:24 AM, Dave Hansen wrote:
> This continues in a series of patches to clean up the
> configuration menus.  I believe they've become really hard to
> navigate and there are some simple things we can do to make
> things easier to find.
> 
> This creates a "Memory Options" menu and moves some things like
> swap and slab configuration under them.  It also moves SLUB_DEBUG
> to the debugging menu.
> 
> After this patch, the menu has the following options:
> 
>   [ ] Memory placement aware NUMA scheduler
>   [*] Enable VM event counters for /proc/vmstat
>   [ ] Disable heap randomization
>   [*] Support for paging of anonymous memory (swap)
>       Choose SLAB allocator (SLUB (Unqueued Allocator))
>   [*] SLUB per cpu partial cache
>   [*] SLUB: attempt to use double-cmpxchg operations



