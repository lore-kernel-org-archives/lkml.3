Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab3JOOig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:38:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57792 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759263Ab3JOOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:38:35 -0400
Date: Tue, 15 Oct 2013 16:38:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
Message-ID: <20131015143819.GM10651@twins.programming.kicks-ass.net>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
 <1381289214-24885-4-git-send-email-dsahern@gmail.com>
 <20131009055957.GA7664@gmail.com>
 <525D4B5F.4090005@gmail.com>
 <20131015143245.GB9828@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015143245.GB9828@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 11:32:45AM -0300, Arnaldo Carvalho de Melo wrote:

> Jiri and PeterZ probaby will have comments here... ;-) :-)

The only complication with splice is the vmalloc support; other than
that it should be fairly straight fwd.
