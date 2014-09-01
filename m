Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaIAHRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:17:08 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:42264 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaIAHRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140901014539.GA10680@verge.net.au>
References: <1409213120-5291-1-git-send-email-geert+renesas@glider.be>
	<20140829003456.GM16165@verge.net.au>
	<CAMuHMdXNPk2ACbFsXcPic_zZBDCjF+5j6-jQNgZxGePPcTRUBQ@mail.gmail.com>
	<20140901005544.GB28783@verge.net.au>
	<20140901014539.GA10680@verge.net.au>
Date: Mon, 1 Sep 2014 09:17:01 +0200
X-Google-Sender-Auth: WRlsWq2ncxCakpWdJBw47hQUb6Q
Message-ID: <CAMuHMdV7=uj3g9Mr_nnCKf7rXOAkpFpnwd6a=8RD1G78=Ovo+g@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: dts: Add shmobile platform device tree bindings documentation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Mon, Sep 1, 2014 at 3:45 AM, Simon Horman <horms@verge.net.au> wrote:
> On Mon, Sep 01, 2014 at 09:55:45AM +0900, Simon Horman wrote:
>> On Fri, Aug 29, 2014 at 10:26:01AM +0200, Geert Uytterhoeven wrote:
>> > > If so I would prefer a slightly re-structured title:
>> > >
>> > > ARM: shmobile: Add platform device tree bindings documentation
>> >
>> > Fine for me.
>> >
>> > Do you want me to resend, or will you amend yourself?
>>
>> No need to resend at this time :)
>
> I have queued up the following:

Looks fine. Thanks!

> From: Geert Uytterhoeven <geert+renesas@glider.be>
>
> [PATCH] ARM: shmobile: Add platform device tree bindings documentation
>
> Add Renesas SH-Mobile, R-Mobile, and R-Car Platform Device Tree Bindings
> Documentation, listing supported SoCs and boards.
>
> This allows to use checkpatch to validate DTSes referring to Renesas
> shmobile SoCs, and boards containing those SoCs.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> [horms+renesas@verge.net.au: tweaked title]
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
