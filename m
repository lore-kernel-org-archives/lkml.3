Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaB1Tmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:42:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaB1Tmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:42:52 -0500
Date: Fri, 28 Feb 2014 14:42:33 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 00/19 V2] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140228194233.GK25953@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <87wqgfawur.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqgfawur.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:57:48AM -0800, Andi Kleen wrote:
> Don Zickus <dzickus@redhat.com> writes:
> >
> > A handful of patches include re-enabling MMAP2 support and some fixes
> > to perf itself.
> 
> I would suggest to pursue the lone kernel patch separately. Hopefully
> that can be merged soon, once the remainin problems with that are 
> addressed.

Good point.

> 
> >
> > Comemnts, feedback, anything else welcomed.
> 
> As a high level comment, can you add support for CSV mode? 
> (-x, in other tools)

It's there. :-)

perf c2c -r -x, report

will spit out raw records in CSV format.

> 
> I assume most people would data mine the output in some form,
> and that's much easier with a more machine oriented format.
> 
> Also you should probably have the standard perf conventions
> for output fds (--log-fd, --output, default to stderr). otherwise
> the output may often be lost.

Ok,  I'll look into what that entails.

Thanks!

Cheers,
Don
