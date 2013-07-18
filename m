Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab3GRTAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:00:40 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38208 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab3GRS7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:59:22 -0400
Message-ID: <51E74143.4040709@gmail.com>
Date: Thu, 18 Jul 2013 03:13:39 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org
Subject: Re: [PATCH 1/3] ptrace.2: place GETSIGINFO and SETSIGINFO near each
 other
References: <1373962773-2041-1-git-send-email-avagin@openvz.org> <1373962773-2041-2-git-send-email-avagin@openvz.org>
In-Reply-To: <1373962773-2041-2-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Andrey. Applied.

M


On 07/16/13 10:19, Andrey Vagin wrote:
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  man2/ptrace.2 | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/man2/ptrace.2 b/man2/ptrace.2
> index 0d77e3f..5fcac2b 100644
> --- a/man2/ptrace.2
> +++ b/man2/ptrace.2
> @@ -255,18 +255,6 @@ On return, the kernel modifies
>  .B iov.len
>  to indicate the actual number of bytes returned.
>  .TP
> -.BR PTRACE_GETSIGINFO " (since Linux 2.3.99-pre6)"
> -Retrieve information about the signal that caused the stop.
> -Copy a
> -.I siginfo_t
> -structure (see
> -.BR sigaction (2))
> -from the tracee to the address
> -.I data
> -in the tracer.
> -.RI ( addr
> -is ignored.)
> -.TP
>  .BR PTRACE_SETREGS ", " PTRACE_SETFPREGS
>  Modify the tracee's general-purpose or floating-point registers,
>  respectively, from the address
> @@ -301,6 +289,18 @@ and
>  is analogous to
>  .BR PTRACE_GETREGSET .
>  .TP
> +.BR PTRACE_GETSIGINFO " (since Linux 2.3.99-pre6)"
> +Retrieve information about the signal that caused the stop.
> +Copy a
> +.I siginfo_t
> +structure (see
> +.BR sigaction (2))
> +from the tracee to the address
> +.I data
> +in the tracer.
> +.RI ( addr
> +is ignored.)
> +.TP
>  .BR PTRACE_SETSIGINFO " (since Linux 2.3.99-pre6)"
>  Set signal information:
>  copy a
> 

