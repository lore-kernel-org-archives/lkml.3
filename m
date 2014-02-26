Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaBZTzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:55:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:60520 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198AbaBZTz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:55:28 -0500
Date: Wed, 26 Feb 2014 14:55:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140226145522.01fc5a97@gandalf.local.home>
In-Reply-To: <405776058.29534.1393264698347.JavaMail.zimbra@efficios.com>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
	<2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
	<20140213154507.4040fb06@gandalf.local.home>
	<1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com>
	<20140224105454.3e1981ba@gandalf.local.home>
	<193756443.29489.1393260936319.JavaMail.zimbra@efficios.com>
	<20140224123926.0a44f32e@gandalf.local.home>
	<405776058.29534.1393264698347.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 17:58:18 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> > The one that I replied to. I can't pull the module patch unless I get
> > an ack from Rusty.
> 
> Do you mean the internal API semantic change you propose for tracepoints ?
> If yes, then how do you consider this a fix worthy of being backported to
> stable ?
> 

No, I was talking about your patch. The one Rusty already said he'll
pull (or I will :-)

-- Steve
