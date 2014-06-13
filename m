Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaFMSSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:18:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50548 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753100AbaFMSSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:18:20 -0400
Date: Fri, 13 Jun 2014 14:18:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 27/38] tools lib traceevent: Add mac80211 plugin
Message-ID: <20140613141817.72195496@gandalf.local.home>
In-Reply-To: <1402682264.4478.30.camel@jlt4.sipsolutions.net>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
	<1386187622-2928-28-git-send-email-acme@infradead.org>
	<20140612231331.2f30b312@gandalf.local.home>
	<1402682264.4478.30.camel@jlt4.sipsolutions.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014 19:57:44 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Thu, 2014-06-12 at 23:13 -0400, Steven Rostedt wrote:
> 
> > While doing my synchronization between trace-cmd and lib traceevent, I
> > noticed that the mac80211 driver is quite different.
> > 
> > Johannes, Jiri states that this plugin no longer works with the latest
> > kernels. Is that true?
> 
> It's very well possible, looks like we changed mac80211 to chandefs and
> the plugin still has channel type ... that's actually quite a while ago.
> Given that nobody noticed, I'll have to assume that nobody uses the
> mac80211 plugin ;-)
> 
> Want to just remove it? I'd probably replace it with a python one anyway
> if I ever need it ... the C code is hard to work with even with all the
> macro magic.

You can send a patch to Jiri to remove it from the kernel. If that goes
in, I'll just pull it into trace-cmd's copy.

Thanks,

-- Steve
