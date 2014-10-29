Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaJ2TMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:12:52 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:64946 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaJ2TMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
References: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
Date: Wed, 29 Oct 2014 20:12:49 +0100
X-Google-Sender-Auth: 2SzgIcma2BTTzsMmmeHKiUwbn_w
Message-ID: <CAMuHMdV2Z0+gon8+LP_7X2h4B4Hb3KAV2vpZ9kRwC2mVFGLWXw@mail.gmail.com>
Subject: Re: [PATCH] CodingStyle: Add a chapter on conditional compilation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 7:15 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> Document several common practices and conventions regarding conditional
> compilation, most notably the preference for ifdefs in headers rather
> than .c files.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

> +If you have a function or variable which may potentially go unused in a
> +particular configuration, and the compiler would warn about its definition
> +going unused, mark the definition as __maybe_unused rather than wrapping it in
> +a preprocessor conditional.  (However, if a function or variable *always* goes
> +unused, delete it.)

Personally, I don't like __maybe_unused. Once it's there, the compiler
will stop warning about it, even if it really becomes unused.

Apart from that:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
