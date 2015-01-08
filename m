Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbbAHOjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:39:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbbAHOjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:39:00 -0500
Date: Thu, 8 Jan 2015 15:38:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20150108143818.GB16094@krava.brq.redhat.com>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
 <20150108142913.GI23965@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108142913.GI23965@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:29:13PM +0100, Peter Zijlstra wrote:
> On Thu, Dec 11, 2014 at 04:12:21PM +0100, Jiri Olsa wrote:
> > Basically we are adding 'perf data convert' command to
> > allow conversion of perf data file into CTF [1] data.
> 
> I cant help myself; CTF remains: "Capture The Flag" for me :-)

I'll take that as an ack ;-)

jirka
