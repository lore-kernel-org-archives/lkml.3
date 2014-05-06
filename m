Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbaEFBD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:03:26 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33988 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395AbaEFBDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:03:25 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 5 May 2014 21:06:56 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1405051443260.31072@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405052104210.1258@vincent-weaver-1.umelst.maine.edu>
References: <20140502172731.GK30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu> <20140505093124.GN17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405051309160.31072@vincent-weaver-1.umelst.maine.edu> <20140505171428.GU26782@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051443260.31072@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Vince Weaver wrote:

> Meanwhile the haswell and AMD machines have been fuzzing away without 
> issue, I don't know why the core2 machine is always the trouble maker.

The haswell has been fuzzing 12 hours with only a NMI dazed/confused 
message.

The AMD A10 machine however has a wedged fuzzer process.  I think a 
different problem than the core2 one.  I don't have a serial console on 
that machine yet, I guess time to set one up.

I do think though that the memory corruption bug has been fixed by the 
patch.

Vince
