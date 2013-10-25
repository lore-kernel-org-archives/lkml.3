Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3JYSO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:14:59 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:56376 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3JYSO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:14:58 -0400
Date: Fri, 25 Oct 2013 15:14:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
Message-ID: <20131025181449.GA1853@ghostprotocols.net>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <1381468543-25334-7-git-send-email-namhyung@kernel.org>
 <CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>
 <20131025130417.GB20423@ghostprotocols.net>
 <526A8F54.2040601@gmail.com>
 <CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 25, 2013 at 07:12:36PM +0100, Frederic Weisbecker escreveu:
> Oh I see. It's possible that my massive conversion to use the comm
> accessor got blind at some point and left over a few things. I
> remember that I only lightly tested that new comm infrastructure. I
> mean I tested a lot of "perf report -s foo,bar" combinations for
> performance comparisons but I haven't tested the perf script and all
> the other perf tools.
> 
> I'll rebase these patches and test that wider before resending.

Thanks for doing that!

- Arnaldo
