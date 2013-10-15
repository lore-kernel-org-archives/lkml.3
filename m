Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3JOPaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:30:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59657 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab3JOPaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:30:13 -0400
Date: Tue, 15 Oct 2013 17:29:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
Message-ID: <20131015152954.GO10651@twins.programming.kicks-ass.net>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
 <1381289214-24885-4-git-send-email-dsahern@gmail.com>
 <20131009055957.GA7664@gmail.com>
 <525D4B5F.4090005@gmail.com>
 <20131015143245.GB9828@ghostprotocols.net>
 <20131015143819.GM10651@twins.programming.kicks-ass.net>
 <20131015152747.GA15979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015152747.GA15979@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 05:27:47PM +0200, Ingo Molnar wrote:
> Wanna send a patch for people to try? Looks like there's real interest in 
> speeding up perf record as much as possible!

I've got a pile of pending bug reports to sort through before I can
start making more bugs ;-)


