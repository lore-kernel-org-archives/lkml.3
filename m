Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbaETCKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:10:11 -0400
Received: from ozlabs.org ([103.22.144.67]:54462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbaETCKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:10:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@infradead.org>, Diego Viola <diego.viola@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <537A17F8.6050109@infradead.org>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com> <87wqf1oi22.fsf@rustcorp.com.au> <20140502153409.329d3b5b426275e8197251a2@linux-foundation.org> <871tw9c6kt.fsf@rustcorp.com.au> <53678ED6.4070502@infradead.org> <87eh07bu60.fsf@rustcorp.com.au> <CA+ToGPFQ0Ku0odkAaU4FKDtGq0TK8hJ+HWvJr8J3wJVwYaO2mg@mail.gmail.com> <CA+ToGPF_GnnNhSUZjmbyu=5Nk=i2cTkoWPiykaO4EKJSfvNh-w@mail.gmail.com> <537A17F8.6050109@infradead.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 May 2014 10:56:14 +0930
Message-ID: <877g5hjl55.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:
> On 05/19/2014 01:11 AM, Diego Viola wrote:
>> I mean "e.g.:" is wrong, it should be e.g. or e.g.,
>
> I don't see that in the wikipedia page.  Are you basing that on
> "in this usage it is sometimes followed by a comma, depending on style."?
>
> I don't see a problem with the colon, since the quoted phrase has some
> conditions in it, like "sometimes" and "depending".  Colons are often used
> to delimit a list or an example, but I'll leave it up to Rusty.

OH NO, it's already been pushed into my modules-next git tree!!

Deepest regrets,
Rusty.
