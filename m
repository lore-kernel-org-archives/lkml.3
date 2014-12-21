Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaLUJrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 04:47:19 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:35676 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaLUJrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 04:47:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141221011409.9D8546604A3@gitolite.kernel.org>
References: <20141221011409.9D8546604A3@gitolite.kernel.org>
Date: Sun, 21 Dec 2014 10:47:16 +0100
X-Google-Sender-Auth: in94sopZBVDVaqc51buSiEE5HJE
Message-ID: <CAMuHMdW0_mCXPEJUrsOfY6-ev1qroQ57B72KTTOr3k0f3jzX1w@mail.gmail.com>
Subject: Re: MAINTAINERS: clk framework git tree moved to kernel.org
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Stephen,

On Sun, Dec 21, 2014 at 2:14 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=baeb0d9b98c3450e22f8f8e4a6619b8b1d5106ff
> Commit:     baeb0d9b98c3450e22f8f8e4a6619b8b1d5106ff
> Parent:     f956165f07839a0643e4e01081787190692a7c29
> Refname:    refs/heads/master
> Author:     Michael Turquette <mturquette@linaro.org>
> AuthorDate: Thu Nov 13 17:18:20 2014 -0800
> Committer:  Michael Turquette <mturquette@linaro.org>
> CommitDate: Thu Nov 13 17:18:20 2014 -0800
>
>     MAINTAINERS: clk framework git tree moved to kernel.org
>
>     Signed-off-by: Michael Turquette <mturquette@linaro.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 46d652f..9244992 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2493,7 +2493,7 @@ COMMON CLK FRAMEWORK
>  M:     Mike Turquette <mturquette@linaro.org>
>  M:     Stephen Boyd <sboyd@codeaurora.org>
>  L:     linux-kernel@vger.kernel.org
> -T:     git git://git.linaro.org/people/mturquette/linux.git
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git

This doesn't seem to exist?
Is there an error in the URL, or am I just too early?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
