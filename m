Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaB1Vam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:30:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:62846 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751931AbaB1Val (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:30:41 -0500
Date: Fri, 28 Feb 2014 16:30:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228163039.6eb6a8d6@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1402281616280.7362@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
	<530C12CA.6070308@zytor.com>
	<alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
	<20140225094352.73e0e28c@gandalf.local.home>
	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
	<40f095f7-605f-4885-951f-31da7d2d637a@email.android.com>
	<alpine.DEB.2.10.1402281616280.7362@vincent-weaver-1.um.maine.edu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 16:18:23 -0500 (EST)
Vince Weaver <vincent.weaver@maine.edu> wrote:

> I was away from the computer this afternoon and of course I have scores of 
> e-mails on this topic now with lots of competing patches.  Is there one 
> in particular I'm supposed to be testing?

I was poking fun at you on IRC for this exact reason:

<rostedt> poor Vince, I keep sending him new patches. "No, don't test this patch, now test this one. Oh wait, try this one instead"
* peterz sees Vince thinking: "stop... sending.. me.. damn... patches... already... !!!11!"
<rostedt> or at least, "Let me finish this test before I cancel it again for another damn patch"
<rostedt> then he's probably doing "I'm not going to run any tests now, until I wait a while to see if there's a new patch to test"

 :-)

Anyway, I would say wait a bit while we sort this out. At least we have
a strong idea of what the bug is. Now we need to agree on the solution.

Vince, you have been really terrific in helping us figure out what was
wrong. I don't want to waste your time until we can all agree on what
the proper fix is. When we do, it would be great if you can test it.

But for now, have a great weekend and thanks for all your hard work in
narrowing down this issue.

-- Steve
