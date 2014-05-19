Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaESUit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:38:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48766 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaESUis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:38:48 -0400
Message-ID: <537A6BD0.9010504@infradead.org>
Date: Mon, 19 May 2014 13:38:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: Use symbolic defines for console loglevels
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
In-Reply-To: <1400524052-25625-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 11:27 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> ... instead of naked numbers.
> 
> Stuff in sysrq.c used to set it to 8 which is supposed to mean above
> default level so set it to DEBUG instead as we're terminating/killing
> all tasks and we want to be verbose there.
> 
> There should be no functionality change resulting from this patch.
> 

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: x86@kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: kgdb-bugreport@lists.sourceforge.net
> Cc: Hedi Berriche <hedi@sgi.com>
> Cc: Mike Travis <travis@sgi.com>
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kernel/head64.c      |  2 +-
>  arch/x86/platform/uv/uv_nmi.c |  2 +-
>  drivers/nubus/nubus.c         | 18 +++++++++---------
>  drivers/tty/sysrq.c           |  8 ++++----
>  include/linux/printk.h        | 15 +++++++++++++--
>  init/main.c                   |  4 ++--
>  kernel/debug/kdb/kdb_bt.c     |  2 +-
>  kernel/debug/kdb/kdb_io.c     |  2 +-
>  kernel/debug/kdb/kdb_main.c   |  2 +-
>  kernel/printk/printk.c        | 13 +++----------
>  10 files changed, 36 insertions(+), 32 deletions(-)


-- 
~Randy
