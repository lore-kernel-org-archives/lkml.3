Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3COPFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:05:35 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48574 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754401Ab3COPFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:05:34 -0400
Date: Fri, 15 Mar 2013 11:05:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Rob Landley <rob@landley.net>, Steven Rostedt <rostedt@goodmis.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Remove text on tracepoint samples
Message-ID: <20130315150531.GA1382@Krystal>
References: <1363359483.1335.110.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363359483.1335.110.camel@x61.thuisdomein>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle (pebolle@tiscali.nl) wrote:
> The tracepoint sample code got removed. Remove a few lines on its usage
> too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
>  Documentation/trace/tracepoints.txt | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/Documentation/trace/tracepoints.txt b/Documentation/trace/tracepoints.txt
> index c0e1cee..da49437 100644
> --- a/Documentation/trace/tracepoints.txt
> +++ b/Documentation/trace/tracepoints.txt
> @@ -81,7 +81,6 @@ tracepoint_synchronize_unregister() must be called before the end of
>  the module exit function to make sure there is no caller left using
>  the probe. This, and the fact that preemption is disabled around the
>  probe call, make sure that probe removal and module unload are safe.
> -See the "Probe example" section below for a sample probe module.
>  
>  The tracepoint mechanism supports inserting multiple instances of the
>  same tracepoint, but a single definition must be made of a given
> @@ -100,17 +99,3 @@ core kernel image or in modules.
>  If the tracepoint has to be used in kernel modules, an
>  EXPORT_TRACEPOINT_SYMBOL_GPL() or EXPORT_TRACEPOINT_SYMBOL() can be
>  used to export the defined tracepoints.
> -
> -* Probe / tracepoint example
> -
> -See the example provided in samples/tracepoints
> -
> -Compile them with your kernel.  They are built during 'make' (not
> -'make modules') when CONFIG_SAMPLE_TRACEPOINTS=m.
> -
> -Run, as root :
> -modprobe tracepoint-sample (insmod order is not important)
> -modprobe tracepoint-probe-sample
> -cat /proc/tracepoint-sample (returns an expected error)
> -rmmod tracepoint-sample tracepoint-probe-sample
> -dmesg
> -- 
> 1.7.11.7
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
