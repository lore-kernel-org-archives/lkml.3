Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3KUNml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:42:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab3KUNmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:42:39 -0500
Date: Thu, 21 Nov 2013 14:42:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 15/22] tools lib traceevent: Change pevent_parse_event to
 return event format
Message-ID: <20131121134213.GA1465@krava.brq.redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
 <1385031680-9014-16-git-send-email-jolsa@redhat.com>
 <20131121082841.5b709947@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121082841.5b709947@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 08:28:41AM -0500, Steven Rostedt wrote:
> On Thu, 21 Nov 2013 12:01:13 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > Changing pevent_parse_event to return 'struct event_format',
> > for the parsed event if the return pointer is specified.
> 
> Can we not change the API of pevent_parse_event(), I use it quite a bit.
> 
> And yes, I'm working hard to keep what's in trace-cmd and the kernel
> identical.
> 
> > 
> > This way we can remove pevent_parse_format which does the
> > same stuff just without 'struct pevent' object.
> 
> Actually, I don't use pevent_parse_format() at all. What about changing
> that one to include the pevent?
> 
> 
> > 
> > The ultimate goal is to always use pevent object when dealing
> > with traceevent library. The reason is that we might need
> > additional processing (like plugins), which is not possible
> > otherwise.
> 
> Right, so add a pevent to the pevent_parse_format() and leave the
> pevent_parse_event() alone. That should make everyone happy :-)

ook, np ;-)

thanks,
jirka
