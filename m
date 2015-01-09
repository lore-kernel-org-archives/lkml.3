Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbbAIKjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:39:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbbAIKjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:39:12 -0500
Date: Fri, 9 Jan 2015 11:38:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCHv2 0/8] perf tools: Add perf data CTF conversion
Message-ID: <20150109103827.GA14750@krava.brq.redhat.com>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
 <20141222150838.GF29096@krava.brq.redhat.com>
 <20150108102826.GC16059@krava.redhat.com>
 <CAM9d7cgiryFhLBu7RC6rGS80pqO7WEHQVBEFpjOuXYUOiACyoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cgiryFhLBu7RC6rGS80pqO7WEHQVBEFpjOuXYUOiACyoA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:52:20PM +0900, Namhyung Kim wrote:
> On Thu, Jan 8, 2015 at 7:28 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > ping
> >
> > On Mon, Dec 22, 2014 at 04:08:38PM +0100, Jiri Olsa wrote:
> >> On Thu, Dec 11, 2014 at 04:12:21PM +0100, Jiri Olsa wrote:
> >> > hi,
> >> > this is follow up on original RFC patchset:
> >> >   http://marc.info/?t=140732735600004&r=1&w=2
> >> >
> >> > Basically we are adding 'perf data convert' command to
> >> > allow conversion of perf data file into CTF [1] data.
> >> >
> >> > v2 changes:
> >> >   - addressed comments from Namhyung
> >> >   - rebased to latest acme's perf/core
> >>
> >> any ack? ;-)
> 
> I didn't give it a try myself but I couldn't find a problem anymore
> during the code review, so feel free to add
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

thanks!

Arnaldo,
I rebased the branch perf/core_ctf_convert to your latest perf/core

jirka
