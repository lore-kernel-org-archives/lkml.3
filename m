Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaE0Xc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:32:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:63678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751363AbaE0Xc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:32:56 -0400
Date: Tue, 27 May 2014 19:32:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Valdis.Kletnieks@vt.edu,
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
Message-ID: <20140527193252.51ff2f75@gandalf.local.home>
In-Reply-To: <20140527162644.cda2f5c93e2c73aa6c2d7328@linux-foundation.org>
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
	<20140527151728.64e8cf59@gandalf.local.home>
	<20140527194359.GD4366@pd.tnic>
	<34707.1401230184@turing-police.cc.vt.edu>
	<20140527225956.GF4366@pd.tnic>
	<20140527162644.cda2f5c93e2c73aa6c2d7328@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 16:26:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

 
> > so that Steve can sleep tonight? :-)
> 
> I think Steve only comes out at night.

Of course. That's because night time is the best time to hit those
Japanese heated toilet seats.

-- Steve
