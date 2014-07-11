Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaGKWku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:40:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaGKWks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:40:48 -0400
Date: Sat, 12 Jul 2014 00:40:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg KH <gregkh@linuxfoundation.org>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
In-Reply-To: <20140711153314.GA6155@kroah.com>
Message-ID: <alpine.LRH.2.00.1407120039120.17906@twin.jikos.cz>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <20140711082956.GC20603@laptop.programming.kicks-ass.net> <20140711153314.GA6155@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Greg KH wrote:

> > On Fri, Jul 11, 2014 at 03:37:17PM +0800, Jiang Liu wrote:
> > > Any comments are welcomed!
> > 
> > Why would anybody _ever_ have a memoryless node? That's ridiculous.
> 
> I'm with Peter here, why would this be a situation that we should even
> support?  Are there machines out there shipping like this?

I am pretty sure I've seen ppc64 machine with memoryless NUMA node.

-- 
Jiri Kosina
SUSE Labs

