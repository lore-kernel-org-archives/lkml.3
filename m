Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaK0Pnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:43:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaK0Pnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:43:40 -0500
Date: Thu, 27 Nov 2014 16:43:02 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Trace Compass Developer Discussions 
	<tracecompass-dev@eclipse.org>
Subject: Re: Support for Perf CTF traces now in master (was Re: FW: [RFC 0/5]
 perf tools: Add perf data CTF conversion)
Message-ID: <20141127154302.GA4924@krava.brq.redhat.com>
References: <53F38C74.4030300@voxpopuli.im>
 <20140820092858.GA1203@krava.brq.redhat.com>
 <53F4F38C.4080407@voxpopuli.im>
 <5457C259.8030605@linutronix.de>
 <545829CA.7040900@voxpopuli.im>
 <20141105125028.GA30087@linutronix.de>
 <545AEA37.601@voxpopuli.im>
 <5460156E.3050601@voxpopuli.im>
 <5463DBD5.9080303@voxpopuli.im>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5463DBD5.9080303@voxpopuli.im>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:14:45PM -0500, Alexandre Montplaisir wrote:
> 
> On 11/09/2014 08:31 PM, Alexandre Montplaisir wrote:
> >On 2014-11-05 10:25 PM, Alexandre Montplaisir wrote:
> >>
> >>>
> >>>>But if you could for example tell me the perf equivalents of all the
> >>>>strings in that file, I could hack together such wrapper. With that,
> >>>>in theory, perf traces should behave exactly the same as LTTng traces
> >>>>in the viewer!
> >>>Oooh, that would be awesome. So I installed maven but didn't get much
> >>>further. Let me gather this for you.
> >>
> >>Awesome, thanks!
> >>
> >>I am travelling this week, so I'm a bit busy, but I will try to
> >>prototype a "wrapper" for the kernel analysis, and adding support for
> >>the perf events, whenever I have a chance. I'll keep you posted.
> >
> >Ok, some good news!
> >
> >I managed to get the CTF traces from perf working in Trace Compass! See
> >attached screenshots. This is showing the "ctf-out2" trace from your
> >previous email. The other trace seems to have less events enabled, so it
> >would only show some WAIT_FOR_CPU states in the view.
> >
> >If anybody wishes to try it, you can grab the whole branch ending at
> >https://git.eclipse.org/r/#/c/36200/ . Or run:
> >$ git fetch
> >git://git.eclipse.org/gitroot/tracecompass/org.eclipse.tracecompass
> >refs/changes/00/36200/3 && git checkout FETCH_HEAD
> 
> Just a quick note, this branch is now merged to master. So anyone who pulls
> the code from the master branch at
> git://git.eclipse.org/gitroot/tracecompass/org.eclipse.tracecompass.git
> should be able to load perf-CTF traces in the viewer. The trace type is now
> called "Common Trace Format -> Linux Kernel Trace" and should support both
> LTTng kernel and perf traces in CTF format (although auto-detection should
> work in most cases).
> 
> This was based on the most recent file format I was aware of, we will update
> it accordingly if required.
> 
> Testing welcome!

hi,
any other way besides compiling eclipse to test this? For pure mortals
with Fedora eclipse rpm.. ;-)

or any instructions for the compilation.. I actually haven't checked yet

thanks,
jirka
