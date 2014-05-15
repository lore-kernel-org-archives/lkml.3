Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaEOTp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:45:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40559 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaEOTp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:45:27 -0400
Date: Thu, 15 May 2014 15:45:23 -0400
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@kernel.org, rusty@rustcorp.com.au, akpm@linux-foundation.org,
        fweisbec@gmail.com, hch@infradead.org, mgorman@suse.de,
        riel@redhat.com, bp@suse.de, rostedt@goodmis.org, mgalbraith@suse.de,
        ego@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 UPDATED 3/3] CPU hotplug, smp: Flush any pending IPI
 callbacks before CPU offline
Message-ID: <20140515194523.GD21306@htj.dyndns.org>
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com>
 <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com>
 <20140515191938.GB21306@htj.dyndns.org>
 <537514D3.4060308@linux.vnet.ibm.com>
 <20140515193656.GM4570@linux.vnet.ibm.com>
 <537518D6.6030006@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537518D6.6030006@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 01:13:18AM +0530, Srivatsa S. Bhat wrote:
> On 05/16/2014 01:06 AM, Paul E. McKenney wrote:
> > On Fri, May 16, 2014 at 12:56:11AM +0530, Srivatsa S. Bhat wrote:
> >> On 05/16/2014 12:49 AM, Tejun Heo wrote:
> >>> Hello,
> >>>
> >>> On Fri, May 16, 2014 at 12:44:13AM +0530, Srivatsa S. Bhat wrote:
> >>>>  /*
> >>>> + * flush_smp_call_function_queue - Flush any pending smp-call-function
> >>>
> >>> Don't we need a blank line here?
> >>
> >> Hmm? That sentence continues on the next line, hence I didn't add any blank
> >> line there.
> > 
> > Tejun might be wanting this to be a docbook comment, in which case
> > it also needs "/**" at the beginning of the comment.
> > 
> 
> Oh, I see. Like this?

Yeah, looks good to me.

Thanks.

-- 
tejun
