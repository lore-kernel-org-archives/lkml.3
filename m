Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaCNNiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbaCNNiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:38:14 -0400
Date: Fri, 14 Mar 2014 09:37:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, jmario@redhat.com, jolsa@redhat.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: perf MMAP2 interface and COW faults
Message-ID: <20140314133748.GY25953@redhat.com>
References: <20140313200352.GU25953@redhat.com>
 <20140314111705.GU27965@twins.programming.kicks-ass.net>
 <20140314125837.GW25953@redhat.com>
 <20140314132447.GW27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314132447.GW27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 02:24:47PM +0100, Peter Zijlstra wrote:
> On Fri, Mar 14, 2014 at 08:58:37AM -0400, Don Zickus wrote:
> > Hmmm.  That will probably work for future mmap events.  My problem is for
> > synthesized mmap events.  We read the same protection bits from
> > /proc/<pid>/maps file, so I assume the same strategy can work for those
> > events too?
> 
> Yeah, so /proc/$pid/maps doesn't contain all those bits, but it does
> have the prot read/write/exec and flags shared/private thing, which
> should be sufficient for your needs.

Great, thanks!

Cheers,
Don

