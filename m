Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBYPbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:31:32 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47658 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaBYPbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:31:31 -0500
Date: Tue, 25 Feb 2014 10:33:37 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <20140225094352.73e0e28c@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu> <530B841F.5050803@zytor.com> <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu> <530B90A5.3090302@zytor.com>
 <20140224141329.1cd3bb52@gandalf.local.home> <20140224193043.GP6835@laptop.programming.kicks-ass.net> <530C12CA.6070308@zytor.com> <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu> <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
 <20140225094352.73e0e28c@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014, Steven Rostedt wrote:

> On Tue, 25 Feb 2014 06:34:55 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > #2 is what I really don't understand.
> > 
> > I worry something else is going on there
> 
> Yeah, me too.
> 

OK, well I'll work on isolating that next, I was hoping the segfault issue 
was related.  It's a lot harder getting traces out of a machine that 
insta-reboots so fast that it can't even finish printing the oops message.

I need my testing machine for some unrelated experiments so I might not 
get a chance to work on this further for a day or two.

Vince
