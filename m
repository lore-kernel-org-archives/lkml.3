Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaE0X0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:26:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaE0X0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:26:47 -0400
Date: Tue, 27 May 2014 16:26:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Valdis.Kletnieks@vt.edu, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: Use symbolic defines for console loglevels
Message-Id: <20140527162644.cda2f5c93e2c73aa6c2d7328@linux-foundation.org>
In-Reply-To: <20140527225956.GF4366@pd.tnic>
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
	<20140527151728.64e8cf59@gandalf.local.home>
	<20140527194359.GD4366@pd.tnic>
	<34707.1401230184@turing-police.cc.vt.edu>
	<20140527225956.GF4366@pd.tnic>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 00:59:57 +0200 Borislav Petkov <bp@alien8.de> wrote:

> @Andrew: can you please replace the sentence:
> 
> "There should be no functionality change resulting from this patch."
> 
> with
> 
> "Also, correct the check in x86_64_start_kernel which should be >= as
> we're clearly issuing the string there for all debug levels, not only
> the magical 10."

Done.

> so that Steve can sleep tonight? :-)

I think Steve only comes out at night.
