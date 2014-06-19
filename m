Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaFSNCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbaFSNCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:02:20 -0400
Date: Thu, 19 Jun 2014 15:02:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] perf tools: Add report.show-headers config file
 option
Message-ID: <20140619130202.GA24328@krava.brq.redhat.com>
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
 <1403178076-14072-6-git-send-email-jolsa@kernel.org>
 <1403182604.1670.26.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403182604.1670.26.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:56:44PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> 2014-06-19 (목), 13:41 +0200, Jiri Olsa:
> > Adding report.show-headers config file option to setup
> > the appearance of the columns headers.
> > 
> > Currently columns headers are displayed by default, following
> > lines in ~/.perfconfig file will disable that:
> > 
> >   [report]
> >         show-headers = true
> 
> This also applies to perf top, right?  And it's TUI-specific.  So how
> about calling it something like "tui.show-headers"?

ook

> 
> 
> [SNIP]
> > @@ -35,6 +35,7 @@ struct symbol_conf symbol_conf = {
> >  	.demangle		= true,
> >  	.cumulate_callchain	= true,
> >  	.symfs			= "",
> > +	.show_headers		= -1,
> 
> Hmm.. why not just making it boolean and set it to true (like others)?

I need 'unset' value, otherwise I dont know if the config
option was unset by user or not touched at all

jirka
