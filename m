Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaEEP5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:57:11 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53732 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaEEP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:57:08 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 5 May 2014 12:00:44 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140505093124.GN17778@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu> <20140502162234.GX11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu> <20140502172731.GK30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu> <20140505093124.GN17778@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Peter Zijlstra wrote:

> Does this one work better? Making sure all __perf_remove_from_context()
> callers pass the right structure seems to improve things no end. My
> machine is now happy to reboot again.

Yes, I've been fuzzing this for a few hours on both my haswell and core2 
test systems and it's doing great, also survived a reboot cycle.

Tested-by: Vince Weaver <vincent.weaver@maine.edu>

(Although often things like to crash the instant my tested-by e-mails 
clear the lkml list.)

I also want to say thanks for all the work everyone has done in getting 
this analyzed and fixed.

Vince


