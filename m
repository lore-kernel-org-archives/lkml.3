Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000AbaBZFkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:40:39 -0500
Received: from ozlabs.org ([203.10.76.45]:35094 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaBZFki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:40:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Berg <johannes@sipsolutions.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
In-Reply-To: <1392970255.4346.14.camel@jlt4.sipsolutions.net>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140211072738.GA24232@gmail.com> <20140211234534.6bc34e57@gandalf.local.home> <877g8zg0ed.fsf@rustcorp.com.au> <20140213161156.3548df43@gandalf.local.home> <878uteecu0.fsf@rustcorp.com.au> <20140220103033.32860caf@gandalf.local.home> <87lhx59yap.fsf@rustcorp.com.au> <20140220230938.0bf9614b@gandalf.local.home> <1392970255.4346.14.camel@jlt4.sipsolutions.net>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 26 Feb 2014 13:21:50 +1030
Message-ID: <8761o24md5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:
> Going on a tangent here - our use case is using backported upstream
> kernel modules (https://backports.wiki.kernel.org/) for delivering a
> driver to people who decided that they absolutely need to run with some
> random kernel (e.g. 3.10) but we don't yet support all the driver
> features they want/need in the kernel they picked.

Ah, a user!  See, that's not the "I forgot to sign my modules" case the
others were complaining about.

> We push our code upstream as soon as we can and typically only diverge
> from upstream by a few patches, so saying things like "crap" or "felony
> law breaker" about out-of-tree modules in general makes me furious.

Appreciated and understood.

I have applied Mathieu's patch to my pending tree, with Ingo's Nack
recorded.

Thanks,
Rusty.
