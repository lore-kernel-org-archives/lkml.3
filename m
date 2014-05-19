Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbaESTgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:36:25 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:54685 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaESTgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <1400524052-25625-1-git-send-email-bp@alien8.de>
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
Date: Mon, 19 May 2014 12:36:20 -0700
X-Google-Sender-Auth: M_DfRInk_0DZexoxohxvuRDLZLM
Message-ID: <CAGXu5jL3TPZimdRo0L2VgjQwBmhbDgHDDSs6-g73Yg4uy5DQEA@mail.gmail.com>
Subject: Re: [PATCH] printk: Use symbolic defines for console loglevels
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:27 AM, Borislav Petkov <bp@alien8.de> wrote:
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

Yes, please. Good clean-up. :)

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
