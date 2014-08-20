Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaHTVGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:06:32 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:38610 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaHTVGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:06:30 -0400
MIME-Version: 1.0
In-Reply-To: <1408566581-14109-1-git-send-email-jim.epost@gmail.com>
References: <1408566581-14109-1-git-send-email-jim.epost@gmail.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Thu, 21 Aug 2014 06:05:58 +0900
Message-ID: <CAEjAshq-8Ph-uW9Upovrtduro4KGLWsbHuZjzw2GWXmTYJ6k6A@mail.gmail.com>
Subject: Re: [PATCH] Documentation: remove outdated references to the
 linux-next wiki
To: Jim Davis <jim.epost@gmail.com>, frank@f-seidel.de
Cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, sfr@canb.auug.org.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 5:29 AM, Jim Davis <jim.epost@gmail.com> wrote:
> The linux-next wiki at http://linux.f-seidel.de/linux-next/pmwiki has
> been gone for several months now.

Yes, I can't load the page, too. BTW, wouldn't it be better to add
Frank Seidel as recipient because he was the manager of the wiki?

I added him as this mail's recipient.

Thank.

>
> Signed-off-by: Jim Davis <jim.epost@gmail.com>
> ---
>  Documentation/HOWTO                            | 1 -
>  Documentation/development-process/2.Process    | 4 ----
>  Documentation/development-process/8.Conclusion | 4 ----
>  3 files changed, 9 deletions(-)
>
> diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> index 57cf5efb044d..93aa8604630e 100644
> --- a/Documentation/HOWTO
> +++ b/Documentation/HOWTO
> @@ -324,7 +324,6 @@ tree, they need to be integration-tested.  For this purpose, a special
>  testing repository exists into which virtually all subsystem trees are
>  pulled on an almost daily basis:
>         http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git
> -       http://linux.f-seidel.de/linux-next/pmwiki/
>
>  This way, the -next kernel gives a summary outlook onto what will be
>  expected to go into the mainline kernel at the next merge period.
> diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
> index 2e0617936e8f..c24e156a6118 100644
> --- a/Documentation/development-process/2.Process
> +++ b/Documentation/development-process/2.Process
> @@ -289,10 +289,6 @@ lists when they are assembled; they can be downloaded from:
>
>         http://www.kernel.org/pub/linux/kernel/next/
>
> -Some information about linux-next has been gathered at:
> -
> -       http://linux.f-seidel.de/linux-next/pmwiki/
> -
>  Linux-next has become an integral part of the kernel development process;
>  all patches merged during a given merge window should really have found
>  their way into linux-next some time before the merge window opens.
> diff --git a/Documentation/development-process/8.Conclusion b/Documentation/development-process/8.Conclusion
> index 1990ab4b4949..caef69022e9c 100644
> --- a/Documentation/development-process/8.Conclusion
> +++ b/Documentation/development-process/8.Conclusion
> @@ -22,10 +22,6 @@ Beyond that, a valuable resource for kernel developers is:
>
>         http://kernelnewbies.org/
>
> -Information about the linux-next tree gathers at:
> -
> -       http://linux.f-seidel.de/linux-next/pmwiki/
> -
>  And, of course, one should not forget http://kernel.org/, the definitive
>  location for kernel release information.
>
> --
> 2.1.0
>
