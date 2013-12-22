Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3LVC7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 21:59:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63177 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751696Ab3LVC7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 21:59:44 -0500
Date: Sat, 21 Dec 2013 21:59:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tracing: Move tracing_alloc_snapshot() declaration
 to tracing.h
Message-ID: <20131221215943.655309c5@gandalf.local.home>
In-Reply-To: <d7a0a7b99848c48e3a4abe50fc94390a1d0ca967.1387662969.git.tom.zanussi@linux.intel.com>
References: <cover.1387662969.git.tom.zanussi@linux.intel.com>
	<d7a0a7b99848c48e3a4abe50fc94390a1d0ca967.1387662969.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Dec 2013 16:44:00 -0600
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> tracing_alloc_snapshot() is only used internally by
> alloc_tracing_snapshot() and trace_event_triggers.c and doesn't need
> to be in kernel.h.  Move it to trace.h, which is more appropriate and
> both include.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>

I simply folded this patch into "tracing: Add 'snapshot' event trigger
command".

The ftrace/core branch can be rebased. I haven't put this into my
for-next branch yet which I do not rebase (unless there's a major
reason to do so).

-- Steve
