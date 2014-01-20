Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaATK2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:28:17 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:63719 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaATK2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:28:09 -0500
Message-ID: <52DCF47C.6040200@gmail.com>
Date: Mon, 20 Jan 2014 11:03:40 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org
Subject: Re: [PATCH 3/3] ptrace.2: add description for PTRACE_{GET,SET}SIGMASK
References: <1373962773-2041-1-git-send-email-avagin@openvz.org> <1373962773-2041-4-git-send-email-avagin@openvz.org>
In-Reply-To: <1373962773-2041-4-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 10:19 AM, Andrey Vagin wrote:
> These two commands allow to examine and change mask of blocked signals.

Thanks, Andrey.

Applied.

Cheers,

Michael


> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  man2/ptrace.2 | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/man2/ptrace.2 b/man2/ptrace.2
> index e74535e..08697ff 100644
> --- a/man2/ptrace.2
> +++ b/man2/ptrace.2
> @@ -356,6 +356,21 @@ If this flag is not set, signals are read from a per-thread queue.
>  .in
>  .PP
>  .TP
> +.BR PTRACE_GETSIGMASK " (since Linux 3.11)"
> +.\" commit 29000caecbe87b6b66f144f72111f0d02fbbf0c1
> +Retrieve mask of blocked signals to the address
> +.I data.
> +The
> +.I addr
> +argument contains the size of mask.
> +.TP
> +.BR PTRACE_SETSIGMASK " (since Linux 3.11)"
> +Change mask of blocked signals from the address
> +.I data.
> +The
> +.I addr
> +argument contains the size of mask.
> +.TP
>  .BR PTRACE_SETOPTIONS " (since Linux 2.4.6; see BUGS for caveats)"
>  Set ptrace options from
>  .IR data .
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
