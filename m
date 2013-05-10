Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3EJUKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 16:10:22 -0400
Received: from www.sr71.net ([198.145.64.142]:40019 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab3EJUKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 16:10:18 -0400
Message-ID: <518D5429.3020609@sr71.net>
Date: Fri, 10 May 2013 13:10:17 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        eranian@google.com
Subject: Re: NMIs induced by 'perf top' hogging all CPU time
References: <518C314C.9040905@sr71.net> <20130510102911.GB31235@dyad.programming.kicks-ass.net>
In-Reply-To: <20130510102911.GB31235@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 03:29 AM, Peter Zijlstra wrote:
> On Thu, May 09, 2013 at 04:29:16PM -0700, Dave Hansen wrote:
>> If I boot a recent kernel (bb9055b) and run 'perf top' on my machine, it
>> hangs.  It is 100% reproducible; it happens every single time.  If I'm
>> lucky, I'll get some of the hardlockup detection messages on the console.
> 
> Are you implicitly saying it worked as expected on previous kernels?

Yes, it works on older kernels.  3.6.11 works, for instance.

This hardware is quite effective at finding bugs.  It makes bisecting
very challenging as not a lot of random mainline versions boot.
