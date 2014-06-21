Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaFUDnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 23:43:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:26127 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752920AbaFUDnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 23:43:10 -0400
Date: Fri, 20 Jun 2014 23:43:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/trace/syscall.h: Use HAVE_SYSCALL_TRACEPOINTS
 instead of TRACEPOINTS
Message-ID: <20140620234308.25a57690@gandalf.local.home>
In-Reply-To: <53A4EEC5.7090801@gmail.com>
References: <53A4EEC5.7090801@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2014 10:32:37 +0800
Chen Gang <gang.chen.5i5j@gmail.com> wrote:
 
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 291c282..a709cbd 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -33,7 +33,7 @@ struct syscall_metadata {
>  	struct ftrace_event_call *exit_event;
>  };
>  
> -#ifdef CONFIG_TRACEPOINTS
> +#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
>  static inline void syscall_tracepoint_update(struct task_struct *p)
>  {
>  	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))

This has already been fixed and is in my for-next branch getting ready
to be pushed.

-- Steve
