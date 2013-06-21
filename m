Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946111Ab3FUV0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:26:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946061Ab3FUV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:26:08 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BUyC4VmaGVwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5V7bKCsQ6TsA:10 a=Mz_pZ2u7bsVrBlvtC6EA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371849967.18733.134.camel@gandalf.local.home>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 21 Jun 2013 17:26:07 -0400
In-Reply-To: <1371848976.18733.130.camel@gandalf.local.home>
References: <1371835898.18733.122.camel@gandalf.local.home>
	 <1371848976.18733.130.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 17:09 -0400, Steven Rostedt wrote:
> On Fri, 2013-06-21 at 13:31 -0400, Steven Rostedt wrote:
> 
> > My testing also triggered another bug, but I'm not sure it's related to
> > these patches or something that already existed. I'm currently
> > investigating it now.
> 
> 
> I haven't been able to reproduce it.

Correction, I am able to reproduce it. The trick is I need to kick off
the test as soon as I get a login prompt, as the gui is still coming up
(this time the crash happened on pulseaudio). The test suite runs the
test when it detects the login. I was trying to reproduce it manually,
which was well after login was set up.

I'll try to make sure I can reproduce it consistently, or at least in a
short number of tries. And then remove all the patches and see if I can
still trigger it.

-- Steve


