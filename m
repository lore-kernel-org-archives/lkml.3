Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaBMVYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:24:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:25663 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751001AbaBMVYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:24:33 -0500
Date: Thu, 13 Feb 2014 16:24:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140213162431.2f312c71@gandalf.local.home>
In-Reply-To: <20140213161156.3548df43@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<877g8zg0ed.fsf@rustcorp.com.au>
	<20140213161156.3548df43@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 16:11:56 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> Although, is "N" the best letter to use for this taint? Not sure, but
> everything else I can think of looks to be already taken. Maybe "X"?
> You know. When you sign your name and don't know how to spell it, you
> just simply use an "X". :-)

I actually think "X" is appropriate. You want signed modules, but the
module being loaded doesn't know how to sign its name, so we simply use
an "X" for it (in the taint flag).

-- Steve
