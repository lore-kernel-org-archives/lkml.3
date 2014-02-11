Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBKH1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:27:44 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47346 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaBKH1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:27:43 -0500
Date: Tue, 11 Feb 2014 08:27:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140211072738.GA24232@gmail.com>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Users have reported being unable to trace non-signed modules loaded 
> within a kernel supporting module signature.

External modules should strive to get out of the 'crap' and
'felony law breaker' categories and we should not make it
easier for them to linger in a broken state.

Nacked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
