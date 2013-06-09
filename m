Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3FIVv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 17:51:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38877 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3FIVv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 17:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzGZPX-Q6KuU2HpRzRKH_W9Tr6SPPbQkCa8qfkMb5y+gg@mail.gmail.com>
References: <alpine.DEB.2.00.1306092034010.24700@ayla.of.borg>
	<CA+55aFzGZPX-Q6KuU2HpRzRKH_W9Tr6SPPbQkCa8qfkMb5y+gg@mail.gmail.com>
Date: Sun, 9 Jun 2013 23:51:28 +0200
X-Google-Sender-Auth: 7nAf4eqr93K7mXAop9btxcG4MrA
Message-ID: <CAMuHMdW89siW=-sGSzBf9Piu9Nsf_nYAoo35apaiLRQFkffdTw@mail.gmail.com>
Subject: Re: [git pull] Exotic architecture fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Lennox Wu <lennox.wu@gmail.com>, linux-c6x-dev@linux-c6x.org,
        Cris <linux-cris-kernel@axis.com>, linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Jun 9, 2013 at 11:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Which of these are critical and have to be in 3.10?

Most (I agree not all) of them are build fixes. Some (the h8300 symbol prefix
commit and the input one) are fixes for regressions introduced in
early v3.10-rc.

I'd like to have as many green builds as possible on
http://kisskb.ellerman.id.au/kisskb/matrix/,
to make it easier to catch regressions.

> And if the answer is not "all of them" (and I *guarantee* you that
> isn't the answer), why did you bother to send it to me after -rc5?

Because I promised to do so when I announced the creation of this branch,
around v3.10-rc2, cfr. https://lkml.org/lkml/2013/5/23/509.

Usually I just send patches like these to Andrew, who forwards them to you near
the last rc of a cycle. But this time I had accumulated so many of them I wanted
to offload him by creating my own branch and pull request.

Thanks for considering pulling anyway!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
