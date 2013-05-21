Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3EUQGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:06:55 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43563 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3EUQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:06:54 -0400
Date: Tue, 21 May 2013 12:06:34 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] perf: net_dropmonitor: Make it work and make it fast
Message-ID: <20130521160634.GB3613@neilslaptop.think-freely.org>
References: <1369096976.3469.131.camel@deadeye.wl.decadent.org.uk>
 <20130521133355.GA3613@neilslaptop.think-freely.org>
 <1369144440.3469.181.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369144440.3469.181.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 02:54:00PM +0100, Ben Hutchings wrote:
> On Tue, 2013-05-21 at 09:33 -0400, Neil Horman wrote:
> > On Tue, May 21, 2013 at 01:42:56AM +0100, Ben Hutchings wrote:
> > > Somewhat surprisingly, the net_dropmonitor reporting script doesn't work
> > > at all.  This series fixes it and then makes it slightly more efficient.
> > > 
> > > Ben.
> > > 
> > It worked fine when I first submitted it.  I wonder if there was a paramter
> > order change at some point that I wasn't CC'ed on.
> 
> The parameter order for the trace event changed in 2.6.39, but that was
> before this script went in.
> 
Hm, I wonder if I developed it on 2.6.38, that sounds like around the time it
went it.
Neil

> Ben.
> 
> > Either way, this all looks good.  Thanks Ben.
> > 
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > > Ben Hutchings (5):
> > >   perf: net_dropmonitor: Fix trace parameter order
> > >   perf: net_dropmonitor: Fix symbol-relative addresses
> > >   perf: net_dropmonitor: Do not assume ordering of dictionaries
> > >   perf: net_dropmonitor: Use bisection in symbol lookup
> > >   perf: net_dropmonitor: Remove progress indicator
> > > 
> > >  tools/perf/scripts/python/net_dropmonitor.py |   39 ++++++++++++++------------
> > >  1 file changed, 21 insertions(+), 18 deletions(-)
> > > 
> > > 
> > 
> > 
> 
> -- 
> Ben Hutchings
> friends: People who know you well, but like you anyway.


