Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaEASfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaEASfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:35:44 -0400
Date: Thu, 1 May 2014 20:35:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [rfc][patch] perf,tools: Remove test_attr_* muck from perf.h
Message-ID: <20140501183505.GA2317@krava.redhat.com>
References: <20140501082729.GM11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501082729.GM11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 10:27:30AM +0200, Peter Zijlstra wrote:
> Hi,
> 
> I occasionally build the odd program against raw perf and use perf.h for
> this.
> 
> Now I find that no longer works because of:
> 
> 52502bf201a85 ("perf tests: Add framework for automated perf_event_attr tests")
> 
> So revert the hunk touching on perf.h.

But but but, then you'll brake attr tests

> 
> Also, it seems to be for snake shit only, and snakes stink, except on a
> plane :-)

wanna get to lwn quotes page, huh? ;)

any details about the breakage? maybe we could find some
way to make you happy and keep the snake shit in place

jirka
