Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaBYOrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:47:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38623 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752483AbaBYOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:47:02 -0500
Date: Tue, 25 Feb 2014 09:43:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140225094352.73e0e28c@gandalf.local.home>
In-Reply-To: <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
	<18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com>
	<alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu>
	<20140224172536.GD9987@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
	<530B841F.5050803@zytor.com>
	<alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
	<530B90A5.3090302@zytor.com>
	<20140224141329.1cd3bb52@gandalf.local.home>
	<20140224193043.GP6835@laptop.programming.kicks-ass.net>
	<530C12CA.6070308@zytor.com>
	<alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014 06:34:55 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> #2 is what I really don't understand.
> 
> I worry something else is going on there

Yeah, me too.

-- Steve

> 
> >
> >While the missing cr2 issue made debugging frustrating, I find the
> >other 
> >aspects of the bug more serious:
> >
> >  1.  Programs that are doing valid memory accesses can segfault
> >and worse
> >2.  This bug can cause an instant-reboot of the system (I assume
> >somehow
> >      with the right combination of memory accesses  it causes a 
> >      triple-fault?)
> >
> >#2 is why I spent all of this time tracking this down, I couldn't leave
> >a 
> >machine fuzzing overnight without the machine rebooting.
> >
> >Vince
> 

