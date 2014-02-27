Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaB0Pda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:33:30 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:41374 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaB0Pd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:33:29 -0500
MIME-Version: 1.0
In-Reply-To: <76266614ae965cacc59033bd20385fbcf6393770.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<76266614ae965cacc59033bd20385fbcf6393770.1393493277.git.rashika.kheria@gmail.com>
Date: Thu, 27 Feb 2014 07:33:28 -0800
X-Google-Sender-Auth: aLeOxuptImQ0Y_rCIMmBXs64Zh0
Message-ID: <CAGXu5jLVfekwi_fgjLDp9zVAenxEUwADM-6Kb=NzP7aJV6n+kw@mail.gmail.com>
Subject: Re: [PATCH 35/46] kernel: Mark function as static in kernel/seccomp.c
From: Kees Cook <keescook@chromium.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 4:20 AM, Rashika Kheria
<rashika.kheria@gmail.com> wrote:
> Mark function as static in kernel/seccomp.c because it is not used
> outside this file.
>
> This eliminates the following warning in kernel/seccomp.c:
> kernel/seccomp.c:296:6: warning: no previous prototype for ‘seccomp_attach_user_filter’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

> ---
>  kernel/seccomp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index b7a1004..0e004a7 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -293,7 +293,7 @@ fail:
>   *
>   * Returns 0 on success and non-zero otherwise.
>   */
> -long seccomp_attach_user_filter(char __user *user_filter)
> +static long seccomp_attach_user_filter(char __user *user_filter)
>  {
>         struct sock_fprog fprog;
>         long ret = -EFAULT;
> --
> 1.7.9.5
>



-- 
Kees Cook
Chrome OS Security
