Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372Ab3E2SHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:07:18 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:42698 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964986Ab3E2SHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:07:13 -0400
MIME-Version: 1.0
In-Reply-To: <1369770459.15552.20.camel@gandalf.local.home>
References: <1369770459.15552.20.camel@gandalf.local.home>
Date: Wed, 29 May 2013 21:01:04 +0300
Message-ID: <CAHp75VdiQT8R257zUrx5vG2DG=A8uJ+bbr1hrEzJdbitFi_jkA@mail.gmail.com>
Subject: Re: [PATCH] trivial/sprintf: Fix typo of witdh to width
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 10:47 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> hex_string() had a typo in a comment.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>

>
> Index: linux-trace.git/lib/vsprintf.c
> ===================================================================
> --- linux-trace.git.orig/lib/vsprintf.c
> +++ linux-trace.git/lib/vsprintf.c
> @@ -670,7 +670,7 @@ static noinline_for_stack
>  char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
>                  const char *fmt)
>  {
> -       int i, len = 1;         /* if we pass '%ph[CDN]', field witdh remains
> +       int i, len = 1;         /* if we pass '%ph[CDN]', field width remains
>                                    negative value, fallback to the default */
>         char separator;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
With Best Regards,
Andy Shevchenko
