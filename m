Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaIKHTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:19:50 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:60832 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaIKHTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:19:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140910155219.3d21aef2df8b1754a736cc1a@linux-foundation.org>
References: <20140908181524.GA11839@www.outflux.net>
	<20140910155219.3d21aef2df8b1754a736cc1a@linux-foundation.org>
Date: Thu, 11 Sep 2014 09:19:46 +0200
X-Google-Sender-Auth: JgeM4A6LN0isa5t_xTEbKWE6bnc
Message-ID: <CAMuHMdUvBdEKCYezARJ8PvuQPQbi+Wq-fwO+Z2cxYXOtVzp5GQ@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Masanari Iida <standby24x7@gmail.com>,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:52 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 8 Sep 2014 11:15:24 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> Check for misspellings, based on Debian's lintian list. Several false
>> positives were removed, and several additional words added that were
>> common in the kernel:
>>
>>       backword backwords
>>       invalide valide
>>       recieves
>>       singed unsinged
>>
>> While going back and fixing existing spelling mistakes isn't a high
>> priority, it'd be nice to try to catch them before they hit the tree.
>
> I have a feeling this is going to be a rat hole and that
> scripts/spelling.txt will grow to consume the planet.  Oh well, whatev.

What about making checkpatch use the codespell dictionay if codespell
is installed?

Codespell is in Ubuntu 14.04LTS (but not in 12.04LTS).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
