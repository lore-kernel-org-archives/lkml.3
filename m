Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaGOBSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:18:13 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64011 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaGOBSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:18:11 -0400
Date: Mon, 14 Jul 2014 18:18:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andi Kleen <andi@firstfloor.org>, Greg KH <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
In-Reply-To: <20140711205106.GB20603@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1407141814090.8808@chino.kir.corp.google.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <20140711082956.GC20603@laptop.programming.kicks-ass.net> <20140711153314.GA6155@kroah.com> <8761j3ve8s.fsf@tassilo.jf.intel.com>
 <20140711205106.GB20603@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Peter Zijlstra wrote:

> > There are other cases too.
> 
> Are there any sane ones?
> 

They are specifically allowed by the ACPI specification to be able to 
include only cpus, I/O, networking cards, etc.
