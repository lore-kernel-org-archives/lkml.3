Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaBXRjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:39:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:48523 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752947AbaBXRj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:39:29 -0500
Date: Mon, 24 Feb 2014 12:39:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140224123926.0a44f32e@gandalf.local.home>
In-Reply-To: <193756443.29489.1393260936319.JavaMail.zimbra@efficios.com>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
	<2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
	<20140213154507.4040fb06@gandalf.local.home>
	<1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com>
	<20140224105454.3e1981ba@gandalf.local.home>
	<193756443.29489.1393260936319.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 16:55:36 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Steven Rostedt" <rostedt@goodmis.org>
> > To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > Cc: "Ingo Molnar" <mingo@kernel.org>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, "Thomas
> > Gleixner" <tglx@linutronix.de>, "Rusty Russell" <rusty@rustcorp.com.au>, "David Howells" <dhowells@redhat.com>,
> > "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > Sent: Monday, February 24, 2014 10:54:54 AM
> > Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> > 
> [...]
> 
> (keeping discussion for later, as I'm busy at a client site)
>  
> > For now, I'm going to push this in, and also mark it for stable.
> 
> Which patch or patches do you plan to pull, and which is marked for stable ?

The one that I replied to. I can't pull the module patch unless I get
an ack from Rusty.

> 
> This thread is a RFC PATCH. I posted a separate more complete patch in
> a separate thread marked [PATCH].

Yeah, I'll post it out soon enough.

-- Steve
