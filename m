Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbbAHO3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:29:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:42958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbbAHO3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:29:18 -0500
Date: Thu, 8 Jan 2015 15:29:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCHv2 0/8] perf tools: Add perf data CTF conversion
Message-ID: <20150108142913.GI23965@worktop.programming.kicks-ass.net>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 04:12:21PM +0100, Jiri Olsa wrote:
> Basically we are adding 'perf data convert' command to
> allow conversion of perf data file into CTF [1] data.

I cant help myself; CTF remains: "Capture The Flag" for me :-)
