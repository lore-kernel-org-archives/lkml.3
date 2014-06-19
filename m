Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905AbaFSQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:59:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbaFSQ7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:59:22 -0400
Date: Thu, 19 Jun 2014 18:58:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] perf tools: Add report.show-headers config file
 option
Message-ID: <20140619165815.GC31520@krava.brq.redhat.com>
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
 <1403178076-14072-6-git-send-email-jolsa@kernel.org>
 <1403182604.1670.26.camel@leonhard>
 <20140619152843.GB20252@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140619152843.GB20252@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 12:28:43PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 19, 2014 at 09:56:44PM +0900, Namhyung Kim escreveu:
> > 2014-06-19 (목), 13:41 +0200, Jiri Olsa:
> > > Adding report.show-headers config file option to setup
> > > the appearance of the columns headers.
> > > 
> > > Currently columns headers are displayed by default, following
> > > lines in ~/.perfconfig file will disable that:
> > > 
> > >   [report]
> > >         show-headers = true
> > 
> > This also applies to perf top, right?  And it's TUI-specific.  So how
> > about calling it something like "tui.show-headers"?
> 
> Why should it be TUI specific? You either show the headers or you don't,
> in all UIs.
> 
> And also in all tools, I think, so I suggest putting it in some global,
> for all tools, section in the config file, i.e. something like
> all.show-headers.

seems like so far we have 'core.' and 'hist.' as non-command specific
config sections (note '.core' does not hold any options yet)

I can add another 'all.' section

jirka
