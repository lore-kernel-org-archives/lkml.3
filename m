Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaBNDcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:32:42 -0500
Received: from mail.efficios.com ([78.47.125.74]:39880 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbaBNDck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:32:40 -0500
Date: Fri, 14 Feb 2014 03:32:42 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <67409022.24778.1392348762048.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140213162431.2f312c71@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140211072738.GA24232@gmail.com> <20140211234534.6bc34e57@gandalf.local.home> <877g8zg0ed.fsf@rustcorp.com.au> <20140213161156.3548df43@gandalf.local.home> <20140213162431.2f312c71@gandalf.local.home>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
Thread-Index: v+lD9cutPnEgFthan2C0E4ZqnglwuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Steven Rostedt" <rostedt@goodmis.org>
> Cc: "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@kernel.org>, "Mathieu Desnoyers"
> <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, "Thomas Gleixner"
> <tglx@linutronix.de>, "David Howells" <dhowells@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> Sent: Thursday, February 13, 2014 4:24:31 PM
> Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> 
> On Thu, 13 Feb 2014 16:11:56 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>  
> > Although, is "N" the best letter to use for this taint? Not sure, but
> > everything else I can think of looks to be already taken. Maybe "X"?
> > You know. When you sign your name and don't know how to spell it, you
> > just simply use an "X". :-)
> 
> I actually think "X" is appropriate. You want signed modules, but the
> module being loaded doesn't know how to sign its name, so we simply use
> an "X" for it (in the taint flag).

I like the "X" idea :) Will prepare an updated patch with it.

Thanks,

Mathieu
 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
