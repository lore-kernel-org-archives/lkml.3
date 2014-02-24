Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaBXQze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:55:34 -0500
Received: from mail.efficios.com ([78.47.125.74]:60330 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaBXQzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:55:32 -0500
Date: Mon, 24 Feb 2014 16:55:36 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <193756443.29489.1393260936319.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140224105454.3e1981ba@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140211234534.6bc34e57@gandalf.local.home> <1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com> <20140213102817.4bfd5eac@gandalf.local.home> <2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com> <20140213154507.4040fb06@gandalf.local.home> <1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com> <20140224105454.3e1981ba@gandalf.local.home>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [129.192.185.163]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
Thread-Index: iKqhasbKmUwgI/P1+PTom/ohXJgVxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Ingo Molnar" <mingo@kernel.org>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, "Thomas
> Gleixner" <tglx@linutronix.de>, "Rusty Russell" <rusty@rustcorp.com.au>, "David Howells" <dhowells@redhat.com>,
> "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> Sent: Monday, February 24, 2014 10:54:54 AM
> Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> 
[...]

(keeping discussion for later, as I'm busy at a client site)
 
> For now, I'm going to push this in, and also mark it for stable.

Which patch or patches do you plan to pull, and which is marked for stable ?

This thread is a RFC PATCH. I posted a separate more complete patch in
a separate thread marked [PATCH].

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
