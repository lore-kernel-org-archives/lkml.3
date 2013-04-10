Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936156Ab3DJLZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:25:04 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35583 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935845Ab3DJLZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:25:01 -0400
Date: Wed, 10 Apr 2013 13:24:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>
Subject: Re: systemtap broken by removal of register_timer_hook
Message-ID: <20130410112456.GA29886@gmail.com>
References: <20130403075017.GA2534@suse.de>
 <CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg__32168.962484184$1364986928$gmane$org@mail.gmail.com>
 <y0mvc83u79f.fsf@fche.csb>
 <CAFTL4hxx_GHoa4uguSAtY0A=cC43qJPKvpqaoguS-WAjFj+HSw@mail.gmail.com>
 <20130403144428.GA15432@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403144428.GA15432@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Hi -
> 
> On Wed, Apr 03, 2013 at 02:49:53PM +0200, Frederic Weisbecker wrote:
> 
> > Sounds good, would you like to propose a version? We are also
> > interested in a timer tick event tracepoint for dynticks debugging.
> 
> How about this?
> 
> Author: Frank Ch. Eigler <fche@redhat.com>
> Date:   Wed Apr 3 10:35:21 2013 -0400
> 
>     profiling: add profile_tick tracepoint
>     
>     Commit ba6fdda4 removed the timer_hook mechanism for modules to listen
>     to profiling timer ticks (without having to set up more complicated
>     perf mechanisms).  To reduce the impact on out-of-tree users, a
>     TRACE_EVENT-flavoured tracepoint is added in its place.  Tested with
>     perf and systemtap.

I'd suggest mentioning SystemTap here as the driving motivation. SystemTap 
triggered a generic kernel improvement here, no need to hide its identity!

Thanks,

	Ingo
