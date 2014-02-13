Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaBMPgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:36:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaBMPgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:36:50 -0500
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 13 Feb 2014 10:36:35 -0500
In-Reply-To: <20140213102817.4bfd5eac@gandalf.local.home> (Steven Rostedt's message of "Thu, 13 Feb 2014 10:28:17 -0500")
Message-ID: <y0mlhxfnhx8.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rostedt wrote:

> [...]
> Oh! You are saying that if the kernel only *supports* signed modules,
> and you load a module that is not signed, it will taint the kernel?

Yes: this is the default for several distros.

- FChE
