Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaCBP7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:59:49 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:61363 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaCBP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:59:48 -0500
Date: Sun, 2 Mar 2014 11:02:01 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <20140228223651.485042cc@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1403021045310.9864@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <20140225094352.73e0e28c@gandalf.local.home> <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com> <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu> <20140227215726.7018c861@gandalf.local.home>
 <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu> <20140228092341.12a40f7c@gandalf.local.home> <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu> <40f095f7-605f-4885-951f-31da7d2d637a@email.android.com>
 <alpine.DEB.2.10.1402281616280.7362@vincent-weaver-1.um.maine.edu> <20140228163039.6eb6a8d6@gandalf.local.home> <alpine.DEB.2.10.1402281829330.7966@vincent-weaver-1.um.maine.edu> <20140228223651.485042cc@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, Steven Rostedt wrote:
> On Fri, 28 Feb 2014 18:34:00 -0500 (EST)
> Vince Weaver <vincent.weaver@maine.edu> wrote:
> 
> But perf_event bug finder is a much more prestigious title than
> "college professor" ;-)

yes, it's something to fall back on if/when I get denied tenure :)

I do enjoy tracking down bugs like this, it's why I spend a lot of time on 
it when I should probably be doing other things.

> BTW, is the perf_fuzzer code posted somewhere? It sounds like it can be
> really useful for us to do our own testing too.

yes, code is fully available though possibly not publicized well.  I 
posted the full info later in the thread as I seem to be responding to 
e-mails in reverse order today for some reason.

Vince
