Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaB1ONg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:13:36 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:45658 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaB1ON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:13:29 -0500
Date: Fri, 28 Feb 2014 09:15:33 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <20140227215726.7018c861@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <530B841F.5050803@zytor.com> <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
 <530B90A5.3090302@zytor.com> <20140224141329.1cd3bb52@gandalf.local.home> <20140224193043.GP6835@laptop.programming.kicks-ass.net> <530C12CA.6070308@zytor.com> <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
 <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com> <20140225094352.73e0e28c@gandalf.local.home> <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com> <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu> <20140227215726.7018c861@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Steven Rostedt wrote:

> On Thu, 27 Feb 2014 20:34:34 -0500 (EST)
> Vince Weaver <vincent.weaver@maine.edu> wrote:
> 
> 
> > > I would actually suggest we do the equivalent on i386 as well.
> > > 
> > > Vince, could you try this patch as an experiment?
> > 
> > OK with your patch applied it does not segfault.
> > 
> 
> Vince, Great! Can you remove Peter's patch, and try this one. It
> removes the crud to save the cr2 from entry_64.S and makes both i386
> and x86_64 do the same thing in regards to cr2 handling.

no, with only this patch applied it segfaults as per previous:

[  126.396049] perf_fuzzer[2904]: segfault at 17a0 ip 00000000004017fd sp 00000000ffaff3f0 error 6 in perf_fuzzer[400000+d1000]

Vince
