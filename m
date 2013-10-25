Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3JYNE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:04:29 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:38289 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab3JYNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:04:25 -0400
Date: Fri, 25 Oct 2013 10:04:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
Message-ID: <20131025130417.GB20423@ghostprotocols.net>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <1381468543-25334-7-git-send-email-namhyung@kernel.org>
 <CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 25, 2013 at 11:56:31AM +0100, Frederic Weisbecker escreveu:
> 2013/10/11 Namhyung Kim <namhyung@kernel.org>:
> > From: Frederic Weisbecker <fweisbec@gmail.com>

> > This new comm infrastructure provides two features:

> I was wondering about the fate of these patches. I can resend these or
> do any rebase if you need to.

So I applied the first few patches, but deferred working on this part,
the comm one, because Jiri Olsa had some problems with it, IIRC, Jiri?
Can you refresh my mind and ellaborate on it?

Thanks!

- Arnaldo
