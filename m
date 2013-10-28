Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3J1JPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:15:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65454 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3J1JP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:15:29 -0400
X-AuditID: 9c930197-b7b3eae00000122e-5f-526e2b2f26c0
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
	<1381468543-25334-7-git-send-email-namhyung@kernel.org>
	<CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>
	<20131025130417.GB20423@ghostprotocols.net>
	<526A8F54.2040601@gmail.com>
	<CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
	<526AB61B.80505@gmail.com> <871u369cq0.fsf@sejong.aot.lge.com>
	<CAFTL4hxbfJy9Tfw2j5ptW5k5AjCBYSuf5_+7U9ShWUQaDqOpdw@mail.gmail.com>
Date: Mon, 28 Oct 2013 18:15:26 +0900
In-Reply-To: <CAFTL4hxbfJy9Tfw2j5ptW5k5AjCBYSuf5_+7U9ShWUQaDqOpdw@mail.gmail.com>
	(Frederic Weisbecker's message of "Mon, 28 Oct 2013 10:09:46 +0100")
Message-ID: <8738nl92oh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Mon, 28 Oct 2013 10:09:46 +0100, Frederic Weisbecker wrote:
> Ah cool! Could you please remind me the name of that branch so that I
> can do some tests and work on top of it?

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
    perf/callchain-v5

Thanks,
Namhyung
