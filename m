Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbaICRC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:02:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:41185 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739AbaICRCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:02:53 -0400
Message-ID: <540749B8.5090302@infradead.org>
Date: Wed, 03 Sep 2014 10:02:48 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org
Subject: Re: [PATCH/v2] perf/documentation: Fix typo in perf/Documentation
References: <5405EDDC.4050808@infradead.org> <1409715963-513-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1409715963-513-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 20:46, Masanari Iida wrote:
> This patch fix spelling typo found in tool/perf/Documentation.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Sorry, I found a few more items that could be fixed...
and I seem to have mucked up yesterday's comments.  :(

> ---
>  tools/perf/Documentation/perf-diff.txt          | 6 +++---
>  tools/perf/Documentation/perf-kvm.txt           | 4 ++--
>  tools/perf/Documentation/perf-list.txt          | 2 +-
>  tools/perf/Documentation/perf-record.txt        | 2 +-
>  tools/perf/Documentation/perf-script-perl.txt   | 4 ++--
>  tools/perf/Documentation/perf-script-python.txt | 6 +++---
>  tools/perf/Documentation/perf-script.txt        | 2 +-
>  tools/perf/Documentation/perf-test.txt          | 2 +-
>  tools/perf/Documentation/perf-trace.txt         | 2 +-
>  9 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
> index 6e689dc..4edbc2b 100644
> --- a/tools/perf/Documentation/perf-kvm.txt
> +++ b/tools/perf/Documentation/perf-kvm.txt
> @@ -100,7 +100,7 @@ OPTIONS
>  STAT REPORT OPTIONS
>  -------------------
>  --vcpu=<value>::
> -       analyze events which occures on this vcpu. (default: all vcpus)
> +       analyze events which occurs on this vcpu. (default: all vcpus)

	                       occur

>  
>  --event=<value>::
>         event to be analyzed. Possible values: vmexit, mmio (x86 only),
> @@ -134,7 +134,7 @@ STAT LIVE OPTIONS
>      Analyze events only for given process ID(s) (comma separated list).
>  
>  --vcpu=<value>::
> -       analyze events which occures on this vcpu. (default: all vcpus)
> +       analyze events which occurs on this vcpu. (default: all vcpus)

	                       occur

>  
>  
>  --event=<value>::
> diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
> index d1d3e5121..9fc5c5d 100644
> --- a/tools/perf/Documentation/perf-test.txt
> +++ b/tools/perf/Documentation/perf-test.txt
> @@ -25,7 +25,7 @@ OPTIONS
>  -------
>  -s::
>  --skip::
> -	Tests to skip (comma separater numeric list).
> +	Tests to skip (comma separator numeric list).

	                     separated

>  
>  -v::
>  --verbose::
> diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
> index 02aac83..524c169 100644
> --- a/tools/perf/Documentation/perf-trace.txt
> +++ b/tools/perf/Documentation/perf-trace.txt
> @@ -20,7 +20,7 @@ scheduling events, etc.
>  This is a live mode tool in addition to working with perf.data files like
>  the other perf tools. Files can be generated using the 'perf record' command
>  but the session needs to include the raw_syscalls events (-e 'raw_syscalls:*').
> -Alernatively, the 'perf trace record' can be used as a shortcut to
> +Alternatively, the 'perf trace record' can be used as a shortcut to

either:
                  the 'perf trace record' command can be used ...
or
                  'perf trace record' can be used ...

>  automatically include the raw_syscalls events when writing events to a file.
>  
>  The following options apply to perf trace; options to perf trace record are
> 

Thanks.

-- 
~Randy
