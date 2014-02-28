Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaB1Xb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:31:58 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:38808 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaB1Xb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:31:56 -0500
Date: Fri, 28 Feb 2014 18:34:00 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <20140228163039.6eb6a8d6@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1402281829330.7966@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com> <20140225094352.73e0e28c@gandalf.local.home> <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com> <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
 <20140227215726.7018c861@gandalf.local.home> <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu> <20140228092341.12a40f7c@gandalf.local.home> <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu> <40f095f7-605f-4885-951f-31da7d2d637a@email.android.com>
 <alpine.DEB.2.10.1402281616280.7362@vincent-weaver-1.um.maine.edu> <20140228163039.6eb6a8d6@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, Steven Rostedt wrote:

> On Fri, 28 Feb 2014 16:18:23 -0500 (EST)
> Vince Weaver <vincent.weaver@maine.edu> wrote:
> 
> > I was away from the computer this afternoon and of course I have scores of 
> > e-mails on this topic now with lots of competing patches.  Is there one 
> > in particular I'm supposed to be testing?
> 
> I was poking fun at you on IRC for this exact reason:
> 
> <rostedt> poor Vince, I keep sending him new patches. "No, don't test this patch, now test this one. Oh wait, try this one instead"
> * peterz sees Vince thinking: "stop... sending.. me.. damn... patches... already... !!!11!"
> <rostedt> or at least, "Let me finish this test before I cancel it again for another damn patch"
> <rostedt> then he's probably doing "I'm not going to run any tests now, until I wait a while to see if there's a new patch to test"

Well while it might appear that I spend all of my days finding perf_event 
bugs, I actually am a college professor so I do occasionally have to run 
off to teach a class, meet with students, or write papers/grants for other 
academics to reject.

It's nice others can reproduce the issue now, it would have saved me a lot 
of trouble, although now in theory I have a much better handle of how to 
use/abuse ftrace so I guess it was worth it.

Once the fix gets into git I'm sure the relentless perf_fuzzer will let us 
know if there are any other issues left.  I do look forward to the day 
when I can leave it running overnight and have a clean syslog the next 
morning.

Vince
