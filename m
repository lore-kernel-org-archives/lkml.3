Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbbAHK3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:29:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbbAHK3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:29:15 -0500
Date: Thu, 8 Jan 2015 11:28:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCHv2 0/8] perf tools: Add perf data CTF conversion
Message-ID: <20150108102826.GC16059@krava.redhat.com>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
 <20141222150838.GF29096@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222150838.GF29096@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping 

On Mon, Dec 22, 2014 at 04:08:38PM +0100, Jiri Olsa wrote:
> On Thu, Dec 11, 2014 at 04:12:21PM +0100, Jiri Olsa wrote:
> > hi,
> > this is follow up on original RFC patchset:
> >   http://marc.info/?t=140732735600004&r=1&w=2
> > 
> > Basically we are adding 'perf data convert' command to
> > allow conversion of perf data file into CTF [1] data.
> > 
> > v2 changes:
> >   - addressed comments from Namhyung
> >   - rebased to latest acme's perf/core
> 
> any ack? ;-)
> 
> thanks,
> jirka
