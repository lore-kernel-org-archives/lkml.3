Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBQVHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:07:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43930 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaBQVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:07:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140217182312.GV7862@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
	<201402121251.06280.arnd@arndb.de>
	<20140217155419.682F7C401D4@trevor.secretlab.ca>
	<1418981.0py7JxXCp8@wuerfel>
	<20140217182312.GV7862@titan.lakedaemon.net>
Date: Mon, 17 Feb 2014 22:07:50 +0100
X-Google-Sender-Auth: M13dnXBfjJGmWNw1fP0pbkHU7TA
Message-ID: <CAMuHMdW7S=o4oHVsNtYo0i_giB5cgWhygo-GgSaA1Kur6m3vng@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 7:23 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>> Could we use a faster hash function that scans the entire device tree and
>> then just feed the output of that into add_device_randomness? We probably
>> can't expect that there is a lot of entropy in the DT blob, so the
>> result wouldn't be all that different in terms of quality of the random
>> seed.
>
> I think it would be easier to identify the few attributes that differ
> from board to board (mac address, serial number, etc), and differ from
> boot to boot (random-seed, timestamp) and just extract and feed those
> in.

Isn't identifying those (mostly) a manual process?
Calculating a fast hash is fully automatic.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
