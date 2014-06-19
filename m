Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaFSP2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:28:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:47778 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372AbaFSP2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:28:49 -0400
Date: Thu, 19 Jun 2014 12:28:43 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] perf tools: Add report.show-headers config file
 option
Message-ID: <20140619152843.GB20252@kernel.org>
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
 <1403178076-14072-6-git-send-email-jolsa@kernel.org>
 <1403182604.1670.26.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403182604.1670.26.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 19, 2014 at 09:56:44PM +0900, Namhyung Kim escreveu:
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

Why should it be TUI specific? You either show the headers or you don't,
in all UIs.

And also in all tools, I think, so I suggest putting it in some global,
for all tools, section in the config file, i.e. something like
all.show-headers.
 
- Arnaldo
