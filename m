Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaIBQSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:18:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:34882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaIBQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:18:41 -0400
Message-ID: <5405EDDC.4050808@infradead.org>
Date: Tue, 02 Sep 2014 09:18:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/documentation: Fix typo in perf/Documentation
References: <1409543182-19589-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1409543182-19589-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/14 20:46, Masanari Iida wrote:
> This patch fix spelling typo found in tool/perf/Documentation.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
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
> index 6e689dc..6039eb0 100644
> --- a/tools/perf/Documentation/perf-kvm.txt
> +++ b/tools/perf/Documentation/perf-kvm.txt
> @@ -100,7 +100,7 @@ OPTIONS
>  STAT REPORT OPTIONS
>  -------------------
>  --vcpu=<value>::
> -       analyze events which occures on this vcpu. (default: all vcpus)
> +       analyze events which occurres on this vcpu. (default: all vcpus)

	                       occurs

>  
>  --event=<value>::
>         event to be analyzed. Possible values: vmexit, mmio (x86 only),
> @@ -134,7 +134,7 @@ STAT LIVE OPTIONS
>      Analyze events only for given process ID(s) (comma separated list).
>  
>  --vcpu=<value>::
> -       analyze events which occures on this vcpu. (default: all vcpus)
> +       analyze events which occurres on this vcpu. (default: all vcpus)

	                       occurs

>  
>  
>  --event=<value>::

-- 
~Randy
