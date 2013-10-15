Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab3JOP1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:27:52 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53631 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329Ab3JOP1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:27:51 -0400
Date: Tue, 15 Oct 2013 17:27:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
Message-ID: <20131015152747.GA15979@gmail.com>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
 <1381289214-24885-4-git-send-email-dsahern@gmail.com>
 <20131009055957.GA7664@gmail.com>
 <525D4B5F.4090005@gmail.com>
 <20131015143245.GB9828@ghostprotocols.net>
 <20131015143819.GM10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015143819.GM10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Oct 15, 2013 at 11:32:45AM -0300, Arnaldo Carvalho de Melo wrote:
> 
> > Jiri and PeterZ probaby will have comments here... ;-) :-)
> 
> The only complication with splice is the vmalloc support; other than 
> that it should be fairly straight fwd.

In the initial version we could skip splice support for vmalloc 
ring-buffer, to keep things simple.

Wanna send a patch for people to try? Looks like there's real interest in 
speeding up perf record as much as possible!

Thanks,

	Ingo
