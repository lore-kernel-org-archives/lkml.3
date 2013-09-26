Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab3IZOID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:08:03 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:53186 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3IZOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:08:00 -0400
Date: Thu, 26 Sep 2013 11:07:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v4)
Message-ID: <20130926140749.GC26159@ghostprotocols.net>
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
 <52443ABC.8020808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52443ABC.8020808@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 26, 2013 at 07:46:36AM -0600, David Ahern escreveu:
> On 9/26/13 2:58 AM, Namhyung Kim wrote:
> >This is a new version of callchain improvement patchset.  I found and
> >fixed bugs in the previous version.  I verified that it produced
> >exactly same output before and after applying rbtree conversion patch
> >(#1).  However after Frederic's new comm infrastructure patches are
> >applied it'd be little different.

> >The patches are on 'perf/callchain-v4' branch in my tree

> >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

> Given recent breakage, has the patchset been run through any tests
> on older kernels that do not support sample_id_all? e.g., 2.6.34
> (WRL4). What about tests with the other perf commands -- script to
> dump events, trace on a file with with multiple processes -- to
> verify no impact on comm output, especially multithreaded processes
> with named threads. I can certainly do those tests in time, but
> can't guarantee a timeframe and want to make sure it gets done
> before merging.

Right, and I don't think this is perf/urgent material at this point in
time, when merged will be for 3.13.

- Arnaldo
