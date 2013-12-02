Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3LBOhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:37:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56956 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751927Ab3LBOhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:37:18 -0500
Date: Mon, 2 Dec 2013 09:37:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] tracepoint: Spell Fix: Write "binay" as "binary"
Message-ID: <20131202093713.662881e7@gandalf.local.home>
In-Reply-To: <32a55f133a8138560044ecdac34f0e5aef97ddc3.1385977486.git.viresh.kumar@linaro.org>
References: <32a55f133a8138560044ecdac34f0e5aef97ddc3.1385977486.git.viresh.kumar@linaro.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Dec 2013 15:15:37 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Binary was written as binay, probably by mistake. Fix it.

This can go through the trivial tree.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  include/linux/tracepoint.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index ebeab36..f0c3e4c 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -274,7 +274,7 @@ static inline void tracepoint_synchronize_unregister(void)
>   * For use with the TRACE_EVENT macro:
>   *
>   * We define a tracepoint, its arguments, its printk format
> - * and its 'fast binay record' layout.
> + * and its 'fast binary record' layout.
>   *
>   * Firstly, name your tracepoint via TRACE_EVENT(name : the
>   * 'subsystem_event' notation is fine.

