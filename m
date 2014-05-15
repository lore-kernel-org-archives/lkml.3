Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbaEOWJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:09:39 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:50455 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaEOWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:09:38 -0400
Date: Fri, 16 May 2014 02:09:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140515220935.GV28328@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <20140508020050.GX39568@redhat.com>
 <20140508073756.GM8607@moon>
 <20140508074930.GN8607@moon>
 <20140508080234.GO8607@moon>
 <alpine.DEB.2.10.1405091211430.13652@vincent-weaver-1.umelst.maine.edu>
 <20140514203924.GE28328@moon>
 <alpine.DEB.2.10.1405150127550.30231@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405150127550.30231@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 01:31:16AM -0400, Vince Weaver wrote:
> On Thu, 15 May 2014, Cyrill Gorcunov wrote:
> 
> > So I'm experiencing the same problem on latest -tip + my patches applied.
> 
> glad it's not just me.
> 
> I find the problem to be reproducible and so in theory it might be 
> possible to generate a small reproducing test case.  
> I meant to do that already but I got distracted by other things.

Please ping me once you manage to create such case.

> 
> I think I managed to have a trace I recorded and replayed recreate the 
> issue, but narrowing things down from a 2000+ syscall trace can be 
> tedious.

I imagine :/

> 
> Let me know if you have any other issues with the perf_fuzzer.

Sure. Because the testing machine I'm having is connected remotely
when hang happens the only notification I get is unresposible
ssh connection, sigh...
