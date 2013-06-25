Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3FYTc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:32:28 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45236 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYTc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130625192300.GA10427@roeck-us.net>
References: <20130625183915.443950649@linuxfoundation.org>
	<20130625192300.GA10427@roeck-us.net>
Date: Tue, 25 Jun 2013 21:32:26 +0200
X-Google-Sender-Auth: IfSgq4UPwIRZ4f3zrLJmQkzEXR0
Message-ID: <CAMuHMdVzqOLTVWHeGEFpkpDTt8hpor9zQpnn4bPDaNEGWnb=SQ@mail.gmail.com>
Subject: Re: [ 00/17] 3.0.84-stable review
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Günther,

On Tue, Jun 25, 2013 at 9:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> Build m68k:defconfig passed
> Build m68k:apollo_defconfig passed
> Build m68k:m5272c3_defconfig failed
> Build m68k:m5307c3_defconfig failed
> Build m68k:m5249evb_defconfig failed
> Build m68k:m5407c3_defconfig failed
> Build m68k:mac_defconfig passed
> Build m68k:multi_defconfig passed
> Build m68k:sun3_defconfig passed
> Build m68k:sun3x_defconfig passed
> Build m68k:mvme16x_defconfig passed
> Build m68k:hp300_defconfig passed

m68k:defconfig is an alias for m68k:multi_defconfig, so you can drop
one of them.

Furthermore, m68k:multi_defconfig is the union of all m68k "classic MMU"
defconfigs, except for sun3_defconfig (due to the incompatible MMU type).
Hence dropping apollo_defconfig, mac_defconfig, sun3x_defconfig,
mvme16x_defconfig, and hp300_defconfig would reduce your build coverage
only marginally. Of course, if you have too many spare cycles ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
