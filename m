Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaJTJJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:09:32 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53085 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaJTJJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <20141020090637.GA3654@pd.tnic>
References: <alpine.DEB.2.02.1410201018230.24954@ayla.of.borg>
	<20141020090637.GA3654@pd.tnic>
Date: Mon, 20 Oct 2014 11:09:28 +0200
X-Google-Sender-Auth: qpIOOpryxTuJrD3yflSZ2dyGUNw
Message-ID: <CAMuHMdV5VPEqJ2WeZTc=Tg_vSRJPYgzQib9m-_fnqLzJ_vpDdA@mail.gmail.com>
Subject: Re: v3.18-rc1 bloat-o-meter
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux Embedded <linux-embedded@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Mon, Oct 20, 2014 at 11:06 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Oct 20, 2014 at 10:37:19AM +0200, Geert Uytterhoeven wrote:
>>       Hi all,
>>
>> Below is the bloat-o-meter output when comparing an m68k/atari_defconfig
>> kernel for v3.17 and v3.18-rc1.
>
> That looks cool, can I run this for other arches too?

Sure. Compile two kernel images, and run

    scripts/bloat-o-meter <image1> <image2>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
