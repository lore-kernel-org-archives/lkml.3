Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaGKPdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:33:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaGKPdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:33:35 -0400
Date: Fri, 11 Jul 2014 08:33:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
Message-ID: <20140711153314.GA6155@kroah.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <20140711082956.GC20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711082956.GC20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 10:29:56AM +0200, Peter Zijlstra wrote:
> On Fri, Jul 11, 2014 at 03:37:17PM +0800, Jiang Liu wrote:
> > Any comments are welcomed!
> 
> Why would anybody _ever_ have a memoryless node? That's ridiculous.

I'm with Peter here, why would this be a situation that we should even
support?  Are there machines out there shipping like this?

greg k-h
