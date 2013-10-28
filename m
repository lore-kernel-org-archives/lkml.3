Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3J1KMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:12:55 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:37664 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3J1KMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:12:54 -0400
Date: Mon, 28 Oct 2013 11:12:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
Message-ID: <20131028101248.GA6491@localhost.localdomain>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <1381468543-25334-7-git-send-email-namhyung@kernel.org>
 <CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>
 <20131025130417.GB20423@ghostprotocols.net>
 <526A8F54.2040601@gmail.com>
 <CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
 <526AB61B.80505@gmail.com>
 <871u369cq0.fsf@sejong.aot.lge.com>
 <CAFTL4hxbfJy9Tfw2j5ptW5k5AjCBYSuf5_+7U9ShWUQaDqOpdw@mail.gmail.com>
 <8738nl92oh.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738nl92oh.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 06:15:26PM +0900, Namhyung Kim wrote:
> Hi Frederic,
> 
> On Mon, 28 Oct 2013 10:09:46 +0100, Frederic Weisbecker wrote:
> > Ah cool! Could you please remind me the name of that branch so that I
> > can do some tests and work on top of it?
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>     perf/callchain-v5

Hmm, I tried to rebase on top of tip:perf/core and git is getting confused I guess with
which is applied and which is out of tree. There have been a lot of changes since
then and thus quite some conflicts.

If you don't mind, I would love if you rebase against latest tip:perf/core as you
know better than me what has been applied and what hasn't.

Thanks!
