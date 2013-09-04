Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463Ab3IDIfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:35:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63122 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab3IDIfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:35:40 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-e4-5226f0da8f44
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 01/24] perf tools: Fix 'make install prefix=...' build rule
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
	<1378032529-18498-2-git-send-email-jolsa@redhat.com>
Date: Wed, 04 Sep 2013 17:35:38 +0900
In-Reply-To: <1378032529-18498-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sun, 1 Sep 2013 12:48:26 +0200")
Message-ID: <87sixlrnl1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun,  1 Sep 2013 12:48:26 +0200, Jiri Olsa wrote:
> Currently we fail for following make command:
>
>   $ sudo make install prefix=/opt/perf
>   ...
>       GEN python/perf.so
>   install -d -m 755 '/opt/perf/bin'
>   install perf '/opt/perf/bin'
>   install perf-archive -t '/opt/perf/libexec/perf-core'
>   install: accessing `/opt/perf/libexec/perf-core': No such file or directory
>   make: *** [install-bin] Error 1
>
> Fixing this by properly creating '/opt/perf/libexec/perf-core'
> directory.
>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
