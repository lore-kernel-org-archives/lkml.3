Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBMElA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:41:00 -0500
Received: from ozlabs.org ([203.10.76.45]:41070 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbaBMEk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:40:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
In-Reply-To: <20140211234534.6bc34e57@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140211072738.GA24232@gmail.com> <20140211234534.6bc34e57@gandalf.local.home>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 13 Feb 2014 13:54:42 +1030
Message-ID: <877g8zg0ed.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> On Tue, 11 Feb 2014 08:27:38 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
>
>> 
>> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> 
>> > Users have reported being unable to trace non-signed modules loaded 
>> > within a kernel supporting module signature.
>> 
>> External modules should strive to get out of the 'crap' and
>> 'felony law breaker' categories and we should not make it
>> easier for them to linger in a broken state.
>> 
>> Nacked-by: Ingo Molnar <mingo@kernel.org>

Well, distributions which sign their modules are sending a pretty strong
"go away" signal already.

I'm ambivalent towards out-of-tree modules, so not tempted unless I see
a bug report indicating a concrete problem.  Then we can discuss...

Cheers,
Rusty.
