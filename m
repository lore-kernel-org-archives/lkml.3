Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaBZMzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:55:23 -0500
Received: from mail.efficios.com ([78.47.125.74]:41497 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaBZMzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:55:22 -0500
Date: Wed, 26 Feb 2014 12:55:20 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <1548442707.30678.1393419320104.JavaMail.zimbra@efficios.com>
In-Reply-To: <8761o24md5.fsf@rustcorp.com.au>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140213161156.3548df43@gandalf.local.home> <878uteecu0.fsf@rustcorp.com.au> <20140220103033.32860caf@gandalf.local.home> <87lhx59yap.fsf@rustcorp.com.au> <20140220230938.0bf9614b@gandalf.local.home> <1392970255.4346.14.camel@jlt4.sipsolutions.net> <8761o24md5.fsf@rustcorp.com.au>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
Thread-Index: CQwkCD8gDRdevl+EEF7Vr60BVMsnsw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Rusty Russell" <rusty@rustcorp.com.au>
> To: "Johannes Berg" <johannes@sipsolutions.net>, "Steven Rostedt" <rostedt@goodmis.org>
> Cc: "Ingo Molnar" <mingo@kernel.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
> linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, "Thomas Gleixner" <tglx@linutronix.de>, "David
> Howells" <dhowells@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> Sent: Tuesday, February 25, 2014 9:51:50 PM
> Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> 
> Johannes Berg <johannes@sipsolutions.net> writes:
> > Going on a tangent here - our use case is using backported upstream
> > kernel modules (https://backports.wiki.kernel.org/) for delivering a
> > driver to people who decided that they absolutely need to run with some
> > random kernel (e.g. 3.10) but we don't yet support all the driver
> > features they want/need in the kernel they picked.
> 
> Ah, a user!  See, that's not the "I forgot to sign my modules" case the
> others were complaining about.
> 
> > We push our code upstream as soon as we can and typically only diverge
> > from upstream by a few patches, so saying things like "crap" or "felony
> > law breaker" about out-of-tree modules in general makes me furious.
> 
> Appreciated and understood.
> 
> I have applied Mathieu's patch to my pending tree, with Ingo's Nack
> recorded.

Hi Rusty,

That RFC patch was superseded by a newer version, posted in a separate thread.
There were documentation and other printout sites to update. I posted the
non-RFC version of the patch here:

https://lkml.org/lkml/2014/2/14/4

(you should have it in your inbox)

Please let me know if I need to repost it.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
