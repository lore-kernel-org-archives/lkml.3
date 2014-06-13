Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaFMR6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:58:01 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:39108 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbaFMR6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:58:00 -0400
Message-ID: <1402682264.4478.30.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 27/38] tools lib traceevent: Add mac80211 plugin
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Fri, 13 Jun 2014 19:57:44 +0200
In-Reply-To: <20140612231331.2f30b312@gandalf.local.home>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
	 <1386187622-2928-28-git-send-email-acme@infradead.org>
	 <20140612231331.2f30b312@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 23:13 -0400, Steven Rostedt wrote:

> While doing my synchronization between trace-cmd and lib traceevent, I
> noticed that the mac80211 driver is quite different.
> 
> Johannes, Jiri states that this plugin no longer works with the latest
> kernels. Is that true?

It's very well possible, looks like we changed mac80211 to chandefs and
the plugin still has channel type ... that's actually quite a while ago.
Given that nobody noticed, I'll have to assume that nobody uses the
mac80211 plugin ;-)

Want to just remove it? I'd probably replace it with a python one anyway
if I ever need it ... the C code is hard to work with even with all the
macro magic.

johannes

