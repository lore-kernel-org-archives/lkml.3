Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3IWJRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:17:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62673 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3IWJRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:17:11 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-24-52400716f3e8
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] perf tools: Use per-file CFLAGS in Makefile
References: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
	<20130921124714.GA8304@krava.brq.redhat.com>
Date: Mon, 23 Sep 2013 18:17:09 +0900
In-Reply-To: <20130921124714.GA8304@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sat, 21 Sep 2013 14:47:14 +0200")
Message-ID: <874n9brj6y.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 21 Sep 2013 14:47:14 +0200, Jiri Olsa wrote:
> On Mon, Sep 16, 2013 at 11:11:16AM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Some files need additional compiler flags to be built successfully.
>> Cleanup Makefile by using optional per-file CFLAGS which look like
>> CFLAGS_dir_filename.o
>
> I like it, but I'm getting following error:
>
>   $ make 
>       ...
>       AR libperf.a
>   ar: util/rbtree.o: No such file or directory
>   make: *** [libperf.a] Error 1
>   $
>
> probably because rbtree object is based in kernel lib
>
>
> Also this patch collides with your previous:
>   perf tools: Separate out GTK codes to libperf-gtk.so
>
> which I needed to revert first to get this one applied.

Thanks for the feedback.  I'll take a look and fix them.

Thanks,
Namhyung
