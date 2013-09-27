Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab3I0CKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:10:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44587 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3I0CKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:10:19 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-3c-5244e9090d5e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain merging (v4)
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
	<52443ABC.8020808@gmail.com>
	<20130926140749.GC26159@ghostprotocols.net>
Date: Fri, 27 Sep 2013 11:10:17 +0900
In-Reply-To: <20130926140749.GC26159@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 26 Sep 2013 11:07:49 -0300")
Message-ID: <87eh8bovzq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 26 Sep 2013 11:07:49 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Sep 26, 2013 at 07:46:36AM -0600, David Ahern escreveu:
>> On 9/26/13 2:58 AM, Namhyung Kim wrote:
>> >This is a new version of callchain improvement patchset.  I found and
>> >fixed bugs in the previous version.  I verified that it produced
>> >exactly same output before and after applying rbtree conversion patch
>> >(#1).  However after Frederic's new comm infrastructure patches are
>> >applied it'd be little different.
>
>> >The patches are on 'perf/callchain-v4' branch in my tree
>
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
>> Given recent breakage, has the patchset been run through any tests
>> on older kernels that do not support sample_id_all? e.g., 2.6.34
>> (WRL4). What about tests with the other perf commands -- script to
>> dump events, trace on a file with with multiple processes -- to
>> verify no impact on comm output, especially multithreaded processes
>> with named threads. I can certainly do those tests in time, but
>> can't guarantee a timeframe and want to make sure it gets done
>> before merging.
>
> Right, and I don't think this is perf/urgent material at this point in
> time, when merged will be for 3.13.

Agreed.  It definitely needs more testing.  I'll try to do some testing
mentioned above.

Thanks,
Namhyung
