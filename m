Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaLHLUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:20:47 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:46143 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaLHLUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:20:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWHn+BcpPjr7x+Y1aRwUgBP54mH=4XpjB1VOd7T76-kjw@mail.gmail.com>
References: <CA+r1ZhhoskOXaRSmcrnbdgapi-FsaKf+dnPHTXGkDvkYbvwQ8Q@mail.gmail.com>
	<543F88BE.4090307@intel.com>
	<20141017070620.GA1538@aaronlu.sh.intel.com>
	<20141017072236.GA12504@aaronlu.sh.intel.com>
	<544F33AF.1000704@intel.com>
	<20141107191127.GB27438@developer>
	<1417350176.27484.10.camel@rzhang1-toshiba>
	<547D59D2.8010906@intel.com>
	<1418009702.19126.14.camel@rzhang1-toshiba>
	<CAMuHMdWHn+BcpPjr7x+Y1aRwUgBP54mH=4XpjB1VOd7T76-kjw@mail.gmail.com>
Date: Mon, 8 Dec 2014 12:20:41 +0100
X-Google-Sender-Auth: 52lWk61k8nmM0uUj7O_OhjVz3Vo
Message-ID: <CAMuHMdW8Yap=VrHaEs-oKbVtRSUSb87qf9JJph7aG-MPuv4f_w@mail.gmail.com>
Subject: Re: [PATCH] Thermal: introduce INT3406 thermal driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Eduardo Valentin <edubezval@gmail.com>,
        Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 11:55 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Unfortunately drivers/thermal/int340x_thermal/Kconfig was missing
> from the patch, hence "make oldconfig" now fails miserably with
>
> drivers/thermal/Kconfig:265: can't open file
> "drivers/thermal/int340x_thermal/Kconfig"

I've lifted the missing file from "[PATCH v3] Thermal: int3406_thermal:
solve the dependency build error" (https://lkml.org/lkml/2014/10/17/38).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
