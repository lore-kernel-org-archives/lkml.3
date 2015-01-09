Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbbAIJ65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:58:57 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbbAIJ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:58:55 -0500
Date: Fri, 9 Jan 2015 10:58:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCHv2 0/8] perf tools: Add perf data CTF conversion
Message-ID: <20150109095838.GC22386@worktop.programming.kicks-ass.net>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
 <20150108142913.GI23965@worktop.programming.kicks-ass.net>
 <20150108143818.GB16094@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108143818.GB16094@krava.brq.redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:38:18PM +0100, Jiri Olsa wrote:
> On Thu, Jan 08, 2015 at 03:29:13PM +0100, Peter Zijlstra wrote:
> > On Thu, Dec 11, 2014 at 04:12:21PM +0100, Jiri Olsa wrote:
> > > Basically we are adding 'perf data convert' command to
> > > allow conversion of perf data file into CTF [1] data.
> > 
> > I cant help myself; CTF remains: "Capture The Flag" for me :-)
> 
> I'll take that as an ack ;-)

Only if this patchset adds the Quake engine such that you have to
capture your profile data ;-)
