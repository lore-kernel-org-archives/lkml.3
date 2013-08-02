Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3HBVjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:39:47 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39480 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3HBVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <1375459978.687125@landley.net>
References: <1375459978.687125@landley.net>
Date: Fri, 2 Aug 2013 23:39:45 +0200
X-Google-Sender-Auth: YttqbG90-Xy6nki1xIh8-aGv7Uk
Message-ID: <CAMuHMdUqq1q1jeARpzHBVXTvPb2j8RvMxFBnQtTF4E85=D1opA@mail.gmail.com>
Subject: Re: [PATCH] Tweak Documentation MAINTAINERS entry.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 6:13 PM, Rob Landley <rob@landley.net> wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d83f70f..6b752df 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2664,6 +2664,10 @@ L:       linux-doc@vger.kernel.org
>  T:     TBD
>  S:     Maintained
>  F:     Documentation/
> +X:     Documentation/zh_CN
> +X:     Documentation/ko_KR
> +X:     Documentation/ja_JP

Does "Documentation/??_??" work, to catch future translations?
Or do we have to use "Documentation/[a-z][a-z]_[A-Z][A-Z]"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
