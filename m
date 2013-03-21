Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3CUBLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:11:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab3CUBLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:11:34 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jy5Uui3MpLgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=jJbohOD5F14A:10 a=7d_E57ReAAAA:8 a=y5Yq1ZyPAAAA:8 a=pW5Q8hvRkxNCRGELzSkA:9 a=QEXdDO2ut3YA:10 a=D6-X0JM3zdQA:10 a=nt6uV6JkblEA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363828293.6345.46.camel@gandalf.local.home>
Subject: Re: [PATCH] [TRIVIAL] Documentation: Remove text on tracepoint
 samples
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, Rob Landley <rob@landley.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 21:11:33 -0400
In-Reply-To: <1363595650.1335.141.camel@x61.thuisdomein>
References: <1363359483.1335.110.camel@x61.thuisdomein>
	 <1363595650.1335.141.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 09:34 +0100, Paul Bolle wrote:
> The tracepoint sample code got removed. Remove a few lines on its usage
> too.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Rob Landley <rob@landley.net>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Rob asked (off list) to submit this for the trivial tree.

Sure, it can go that path.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
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


