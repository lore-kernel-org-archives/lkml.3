Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaGKUVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:21:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:14845 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbaGKUVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:21:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,644,1400050800"; 
   d="scan'208";a="560664560"
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
	<20140711082956.GC20603@laptop.programming.kicks-ass.net>
	<20140711153314.GA6155@kroah.com>
Date: Fri, 11 Jul 2014 13:20:51 -0700
In-Reply-To: <20140711153314.GA6155@kroah.com> (Greg KH's message of "Fri, 11
	Jul 2014 08:33:14 -0700")
Message-ID: <8761j3ve8s.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Fri, Jul 11, 2014 at 10:29:56AM +0200, Peter Zijlstra wrote:
>> On Fri, Jul 11, 2014 at 03:37:17PM +0800, Jiang Liu wrote:
>> > Any comments are welcomed!
>> 
>> Why would anybody _ever_ have a memoryless node? That's ridiculous.
>
> I'm with Peter here, why would this be a situation that we should even
> support?  Are there machines out there shipping like this?

We've always had memory nodes.

A classic case in the old days was a two socket system where someone
didn't populate any DIMMs on the second socket.

There are other cases too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
