Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaEFQGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:06:55 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33738 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaEFQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:06:54 -0400
Date: Tue, 6 May 2014 20:06:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140506160651.GO28248@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506154637.GW26782@laptop.programming.kicks-ass.net>
 <20140506154901.GL28248@moon>
 <alpine.DEB.2.10.1405061205030.3372@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405061205030.3372@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 12:05:41PM -0400, Vince Weaver wrote:
> On Tue, 6 May 2014, Cyrill Gorcunov wrote:
> 
> > On Tue, May 06, 2014 at 05:46:37PM +0200, Peter Zijlstra wrote:
> > > On Tue, May 06, 2014 at 11:42:58AM -0400, Vince Weaver wrote:
> > > > 
> > > > So just to be difficult I fired up the perf_fuzzer on a Pentium 4 machine.
> > > > 
> > > > It crashes more or less instantly (sorry for the line wrapping, 
> > > > just got the serial console hooked up and don't have minicom configured 
> > > > right yet).
> > > > 
> > > > this is 3.15-rc4 with the anti-memory corruption patch applied.
> > > 
> > > *sigh*.. the one x86 PMU driver I really don't know. I might actually
> > > have some P4 class hardware, I'll try and get it wired up this week
> > > somewhere.
> > 
> > I'll take a look, thanks.
> 
> This happens quickly enough I can probably generate a small test case, but 
> I won't have time to do that until maybe tomorrow.

I'm quite busy until night as well, so no rush.
