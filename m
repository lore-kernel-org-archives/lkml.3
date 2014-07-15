Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbaGOBUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:20:00 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:57436 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbaGOBT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:19:58 -0400
Date: Mon, 14 Jul 2014 18:19:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jiri Kosina <jkosina@suse.cz>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
In-Reply-To: <alpine.LRH.2.00.1407120039120.17906@twin.jikos.cz>
Message-ID: <alpine.DEB.2.02.1407141818590.8808@chino.kir.corp.google.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <20140711082956.GC20603@laptop.programming.kicks-ass.net> <20140711153314.GA6155@kroah.com> <alpine.LRH.2.00.1407120039120.17906@twin.jikos.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2014, Jiri Kosina wrote:

> I am pretty sure I've seen ppc64 machine with memoryless NUMA node.
> 

Yes, Nishanth Aravamudan (now cc'd) has been working diligently on the 
problems that have been encountered, including problems in generic kernel 
code, on powerpc with memoryless nodes.
