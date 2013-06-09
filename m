Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3FIIeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 04:34:21 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45971 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3FIIeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 04:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Date: Sun, 9 Jun 2013 10:34:08 +0200
X-Google-Sender-Auth: VcQfttRNsWQUJfBG3jpoPQqUs9w
Message-ID: <CAMuHMdXsnNMGUNKXaoUYCNnrCi2jv-acktzF_+g0yfEm7Lo-Og@mail.gmail.com>
Subject: Re: Immutable biovecs, dio rewrite
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 4:18 AM, Kent Overstreet <koverstreet@google.com> wrote:
>  * Changing all the drivers to go through the iterator means that we can
>    submit a partially completed bio to generic_make_request() - this
>    previously worked on some drivers, but worked on others.

Some negation is missing in this sentence?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
