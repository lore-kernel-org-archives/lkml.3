Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaE0XAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:00:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52499 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbaE0XAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:00:00 -0400
Date: Wed, 28 May 2014 00:59:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
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
Message-ID: <20140527225956.GF4366@pd.tnic>
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
 <20140527151728.64e8cf59@gandalf.local.home>
 <20140527194359.GD4366@pd.tnic>
 <34707.1401230184@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <34707.1401230184@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 06:36:24PM -0400, Valdis.Kletnieks@vt.edu wrote:
> If you don't split it out, you should at least mention the bugfix in
> the changelog....

Ok ok, I give up. Steve is bugging me on IRC about it, too. Damn. Ok, I
got it.

@Andrew: can you please replace the sentence:

"There should be no functionality change resulting from this patch."

with

"Also, correct the check in x86_64_start_kernel which should be >= as
we're clearly issuing the string there for all debug levels, not only
the magical 10."

so that Steve can sleep tonight? :-)

Or do you want me to resend with corrected changelog?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
