Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969AbaDIXgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:36:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51708 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804AbaDIXgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:36:20 -0400
Message-ID: <5345D912.7000606@zytor.com>
Date: Wed, 09 Apr 2014 16:34:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-X86 <x86@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for _PAGE_NUMA
 v2
References: <1396962570-18762-1-git-send-email-mgorman@suse.de> <53440A5D.6050301@zytor.com> <CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com> <20140408164652.GL7292@suse.de> <20140408173031.GS10526@twins.programming.kicks-ass.net> <20140409062103.GA7294@gmail.com>
In-Reply-To: <20140409062103.GA7294@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 11:21 PM, Ingo Molnar wrote:
> 
> I think the real underlying objection was that PTE_NUMA was the last 
> leftover from AutoNUMA, and removing it would have made it not a 
> 'compromise' patch set between 'AutoNUMA' and 'sched/numa', but would 
> have made the sched/numa approach 'win' by and large.
> 
> The whole 'losing face' annoyance that plagues all of us (me 
> included).
> 
> I didn't feel it was important to the general logic of adding access 
> pattern aware NUMA placement logic to the scheduler, and I obviously 
> could not ignore the NAKs from various mm folks insisting on PTE_NUMA, 
> so I conceded that point and Mel built on that approach as well.
> 
> Nice it's being cleaned up, and I'm pretty happy about how NUMA 
> balancing ended up looking like.
> 

How painful would it be to get rid of _PAGE_NUMA entirely?  Page bits
are a highly precious commodity and saving one would be valuable.

	-hpa


