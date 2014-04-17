Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaDQX4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:56:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:25378 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736AbaDQX4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:56:42 -0400
Date: Thu, 17 Apr 2014 19:56:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] kernel/trace: add static to local functions
Message-ID: <20140417195640.2d0bf50b@gandalf.local.home>
In-Reply-To: <20140417214442.d7abc7c0b0e4b90e7fedecc9@skynet.be>
References: <20140417214442.d7abc7c0b0e4b90e7fedecc9@skynet.be>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 21:44:42 +0200
Fabian Frederick <fabf@skynet.be> wrote:

> This patch adds static to the following functions:
> -cycle_t buffer_ftrace_now
> -void free_snapshot
> -int trace_selftest_startup_dynamic_tracing
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  kernel/trace/trace.c          | 4 ++--
>  kernel/trace/trace_selftest.c | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 

Thanks, I'll add this to my 3.16 queue.

-- Steve
