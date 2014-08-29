Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaH2I0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:26:07 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:63662 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaH2I0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:26:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140829003456.GM16165@verge.net.au>
References: <1409213120-5291-1-git-send-email-geert+renesas@glider.be>
	<20140829003456.GM16165@verge.net.au>
Date: Fri, 29 Aug 2014 10:26:01 +0200
X-Google-Sender-Auth: X4OAKTGzIBaVIiKJop6AniV2ay4
Message-ID: <CAMuHMdXNPk2ACbFsXcPic_zZBDCjF+5j6-jQNgZxGePPcTRUBQ@mail.gmail.com>
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

On Fri, Aug 29, 2014 at 2:34 AM, Simon Horman <horms@verge.net.au> wrote:
> On Thu, Aug 28, 2014 at 10:05:20AM +0200, Geert Uytterhoeven wrote:
>> Add Renesas SH-Mobile, R-Mobile, and R-Car Platform Device Tree Bindings
>> Documentation, listing supported SoCs and boards.
>>
>> This allows to use checkpatch to validate DTSes referring to Renesas
>> shmobile SoCs, and boards containing those SoCs.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Thanks Geert, this looks good to me.
> Is it for me to pick up?

I think so.

> If so I would prefer a slightly re-structured title:
>
> ARM: shmobile: Add platform device tree bindings documentation

Fine for me.

Do you want me to resend, or will you amend yourself?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
