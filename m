Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaEUC6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:58:45 -0400
Received: from ozlabs.org ([103.22.144.67]:32993 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaEUC6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:58:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Diego Viola <diego.viola@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <CA+ToGPEsrAdm+5MGcvw_4312bU1GtvbNw_sNH8EaegKgd0vV8Q@mail.gmail.com>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com> <87wqf1oi22.fsf@rustcorp.com.au> <20140502153409.329d3b5b426275e8197251a2@linux-foundation.org> <871tw9c6kt.fsf@rustcorp.com.au> <53678ED6.4070502@infradead.org> <87eh07bu60.fsf@rustcorp.com.au> <CA+ToGPFQ0Ku0odkAaU4FKDtGq0TK8hJ+HWvJr8J3wJVwYaO2mg@mail.gmail.com> <CA+ToGPF_GnnNhSUZjmbyu=5Nk=i2cTkoWPiykaO4EKJSfvNh-w@mail.gmail.com> <537A17F8.6050109@infradead.org> <877g5hjl55.fsf@rustcorp.com.au> <CA+ToGPEsrAdm+5MGcvw_4312bU1GtvbNw_sNH8EaegKgd0vV8Q@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 21 May 2014 11:22:37 +0930
Message-ID: <87k39fj3tm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Viola <diego.viola@gmail.com> writes:
> Can't you just make a commit to fix it? If you want I can submit a patch.
>
> Sorry to be so OCD about this.

You know, I'd love to.  If it were up to *me* I would.  But my boss is a
stickler, y'know, and I've all filled my quota of useless makework for
the century.  Hell, I shouldn't even be talking to you!

Cheers,
Rusty.
PS. Try the trivial patch monkey: trivial@kernel.org




 
