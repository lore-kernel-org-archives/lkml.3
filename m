Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3KVWFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:05:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58009 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab3KVWFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:05:42 -0500
Message-ID: <528FD529.7000201@infradead.org>
Date: Fri, 22 Nov 2013 14:05:29 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>, rob@landley.net
CC: joe@perches.com, jkosina@suse.cz, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] doc: fix generation of device-drivers
References: <1384937428-15731-1-git-send-email-nicolas.dichtel@6wind.com>
In-Reply-To: <1384937428-15731-1-git-send-email-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 00:50, Nicolas Dichtel wrote:
> Since commit 7a6354e241d8 ("sched: Move wait.c into kernel/sched/"), the path
> of this file has changed.

This is a fatal kernel-doc error.  Please merge quickly/soon.  Thanks.

> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  Documentation/DocBook/device-drivers.tmpl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 6c9d9d37c83a..f5170082bdb3 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -58,7 +58,7 @@
>       </sect1>
>       <sect1><title>Wait queues and Wake events</title>
>  !Iinclude/linux/wait.h
> -!Ekernel/wait.c
> +!Ekernel/sched/wait.c
>       </sect1>
>       <sect1><title>High-resolution timers</title>
>  !Iinclude/linux/ktime.h
> 


-- 
~Randy
