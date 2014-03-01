Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaCAAoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:44:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49432 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaCAAog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:44:36 -0500
Message-ID: <53112D3B.40807@zytor.com>
Date: Fri, 28 Feb 2014 16:43:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com> <20140225094352.73e0e28c@gandalf.local.home> <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com> <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu> <20140227215726.7018c861@gandalf.local.home> <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu> <20140228092341.12a40f7c@gandalf.local.home> <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu> <40f095f7-605f-4885-951f-31da7d2d637a@email.android.com> <alpine.DEB.2.10.1402281616280.7362@vincent-weaver-1.um.maine.edu> <20140228163039.6eb6a8d6@gandalf.local.home> <alpine.DEB.2.10.1402281829330.7966@vincent-weaver-1.um.maine.edu>
In-Reply-To: <alpine.DEB.2.10.1402281829330.7966@vincent-weaver-1.um.maine.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 03:34 PM, Vince Weaver wrote:
> 
> Well while it might appear that I spend all of my days finding perf_event 
> bugs, I actually am a college professor so I do occasionally have to run 
> off to teach a class, meet with students, or write papers/grants for other 
> academics to reject.
> 

We really appreciate your help.  This has been really critical.

>
> It's nice others can reproduce the issue now, it would have saved me a lot 
> of trouble, although now in theory I have a much better handle of how to 
> use/abuse ftrace so I guess it was worth it.
> 
> Once the fix gets into git I'm sure the relentless perf_fuzzer will let us 
> know if there are any other issues left.  I do look forward to the day 
> when I can leave it running overnight and have a clean syslog the next 
> morning.
> 

We all do, definitely, and your help has been a huge step in that direction.

	-hpa


