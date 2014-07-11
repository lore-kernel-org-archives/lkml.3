Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaGKXwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:52:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40473 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaGKXwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:52:11 -0400
Message-ID: <53C07865.2040103@zytor.com>
Date: Fri, 11 Jul 2014 16:51:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Greg KH <gregkh@linuxfoundation.org>
CC: Jiang Liu <jiang.liu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>	<20140711082956.GC20603@laptop.programming.kicks-ass.net>	<20140711153314.GA6155@kroah.com> <8761j3ve8s.fsf@tassilo.jf.intel.com>
In-Reply-To: <8761j3ve8s.fsf@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 01:20 PM, Andi Kleen wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
>> On Fri, Jul 11, 2014 at 10:29:56AM +0200, Peter Zijlstra wrote:
>>> On Fri, Jul 11, 2014 at 03:37:17PM +0800, Jiang Liu wrote:
>>>> Any comments are welcomed!
>>>
>>> Why would anybody _ever_ have a memoryless node? That's ridiculous.
>>
>> I'm with Peter here, why would this be a situation that we should even
>> support?  Are there machines out there shipping like this?
> 
> We've always had memory nodes.
> 
> A classic case in the old days was a two socket system where someone
> didn't populate any DIMMs on the second socket.
> 
> There are other cases too.
> 

Yes, like a node controller-based system where the system can be
populated with either memory cards or CPU cards, for example.  Now you
can have both memoryless nodes and memory-only nodes...

Memory-only nodes also happen in real life.  In some cases they are done
by permanently putting low-frequency CPUs to sleep for their memory
controllers.
	
	-hpa


