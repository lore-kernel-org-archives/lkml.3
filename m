Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3FXIt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:49:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60126 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3FXItz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <51C802DA.4080202@mentor.com>
References: <51C802DA.4080202@mentor.com>
Date: Mon, 24 Jun 2013 10:49:54 +0200
X-Google-Sender-Auth: 1NPUkyu4rAi5XaRRbMirb_rKlvs
Message-ID: <CAMuHMdXDrPxw2Fs7ncATz+8JTJYu=dm3m0bQrca4KY9UZvyV8A@mail.gmail.com>
Subject: Re: SLIP: Is there a maintainer for drivers/net/slip/slip.c ?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dean Jenkins <Dean_Jenkins@mentor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 10:27 AM, Dean Jenkins <Dean_Jenkins@mentor.com> wrote:
> Using the Linux v3.9 tag, I note that
>
> ./scripts/get_maintainer.pl -f drivers/net/slip/slip.c
> netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> linux-kernel@vger.kernel.org (open list)
>
> There seems to be no maintainer for drivers/net/slip/slip.c, is that true ?

netdev seems to be the most appropriate mailing list, cfr. what
get_maintainer.pl reported, hence CC netdev added.

> I am asking because sl_encaps() and slip_write_wakeup() do not handle error
> codes from tty->ops->write() and a recursive stack overflow crash can occur
> if the tty->ops->write() fails to write all the characters. I have some
> patches to fix this but would like some feedback on an appropriate solution.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
