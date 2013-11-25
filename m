Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3KYJb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:31:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab3KYJbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:31:24 -0500
Date: Mon, 25 Nov 2013 10:30:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 01/22] tools lib traceevent: Add plugin support
Message-ID: <20131125093056.GA3161@krava.brq.redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
 <1385031680-9014-2-git-send-email-jolsa@redhat.com>
 <1385129826.1747.22.camel@leonhard>
 <20131123031219.5426ffa9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123031219.5426ffa9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 03:12:19AM -0500, Steven Rostedt wrote:

SNIP

> > > +	if (!handle) {
> > > +		warning("could not load plugin '%s'\n%s\n",
> > > +			plugin, dlerror());
> > > +		goto out_free;
> > > +	}
> > > +
> > > +	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
> > > +	if (!alias)
> > > +		alias = file;
> > 
> > So this 'alias' is not used anywhere in the current code, right?
> > Do you plan to add the option processing soon?
> 
> I believe he is, and hopefully he will, because I want to forward port
> this code to have trace-cmd use it. The end result should be a separate
> library that we all can use.

yep, thats the plan ;-)

so I get the the deal is in v2 I keep the current code and add
patches addressing comments on top of it..

jirka
