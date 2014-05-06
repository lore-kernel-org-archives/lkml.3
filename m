Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaEFRwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:52:33 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38196 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaEFRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:52:32 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 6 May 2014 13:56:09 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140506161613.GP28248@moon>
Message-ID: <alpine.DEB.2.10.1405061354590.3992@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu> <20140506154637.GW26782@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405061205550.3372@vincent-weaver-1.umelst.maine.edu> <20140506161613.GP28248@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Cyrill Gorcunov wrote:

> On Tue, May 06, 2014 at 12:11:49PM -0400, Vince Weaver wrote:
> > 
> > If I had infinite time I'd try to get the SGI Octane, Ultrasparc, and 
> > avr32 boards up and going again.
> 
> Btw, Vince, perf_fuzzer -- it's http://web.eece.maine.edu/~vweaver/projects/perf_events/fuzzer/?

Yes.

Quick start instructions:

	git clone git://github.com/deater/perf_event_tests
	cd fuzzer
	make
	./fast_repro98.sh

and I find the bug triggers pretty quickly after that.

Vince
