Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaGKUvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:51:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaGKUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:51:17 -0400
Date: Fri, 11 Jul 2014 22:51:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
Message-ID: <20140711205106.GB20603@laptop.programming.kicks-ass.net>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <20140711082956.GC20603@laptop.programming.kicks-ass.net>
 <20140711153314.GA6155@kroah.com>
 <8761j3ve8s.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761j3ve8s.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:20:51PM -0700, Andi Kleen wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > On Fri, Jul 11, 2014 at 10:29:56AM +0200, Peter Zijlstra wrote:
> >> On Fri, Jul 11, 2014 at 03:37:17PM +0800, Jiang Liu wrote:
> >> > Any comments are welcomed!
> >> 
> >> Why would anybody _ever_ have a memoryless node? That's ridiculous.
> >
> > I'm with Peter here, why would this be a situation that we should even
> > support?  Are there machines out there shipping like this?
> 
> We've always had memory nodes.
> 
> A classic case in the old days was a two socket system where someone
> didn't populate any DIMMs on the second socket.

That's a obvious; don't do that then case. Its silly.

> There are other cases too.

Are there any sane ones?
