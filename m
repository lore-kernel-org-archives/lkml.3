Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3JRM0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:26:32 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:50396 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab3JRM0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:26:30 -0400
MIME-Version: 1.0
In-Reply-To: <1382097633-10166-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382097633-10166-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Fri, 18 Oct 2013 14:20:54 +0200
X-Google-Sender-Auth: nNfPHJqf4CWeRSP3VZMHJQnTHYU
Message-ID: <CAMuHMdXas3ALeMXkj1YuDARVAL4Ln19UjXm8oRiGoLyKBc_B7A@mail.gmail.com>
Subject: Re: [PATCH v2] init: make init failures more explicit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        janne.karhunen@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 2:00 PM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> +               pr_err("Starting init: %s exists but couldn't execute it (error: %d - see errno-base.h and errno.h)\n",

IMHO the "- see errno-base.h and errno.h" is a bit overkill.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
