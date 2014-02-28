Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaB1IBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:01:48 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42101 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaB1IBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:01:46 -0500
MIME-Version: 1.0
In-Reply-To: <10401513.fZZM0mLxSj@avalon>
References: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
	<1462634.UcxrmdxVtK@avalon>
	<CAMuHMdU6R_Wubsx2KCAXVBynzqquJekDNDZ-Sq1sKYEOM1RtTw@mail.gmail.com>
	<10401513.fZZM0mLxSj@avalon>
Date: Fri, 28 Feb 2014 09:01:45 +0100
X-Google-Sender-Auth: U82OxSooayUMBzaUSrCeG6kyJ4U
Message-ID: <CAMuHMdVXFnzECcGoywZS=p=ZkkYEYJbaPQoseQSGWYBeT0Y9Tg@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] spi: sh-msiof: Add support for R-Car H2 and M2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Bastian Hecht <hechtb@gmail.com>, Mark Brown <broonie@kernel.org>,
        Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Fri, Feb 28, 2014 at 12:02 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> And if we remove "renesas,sh-msiof", we should probably remove
>> "renesas,sh-mobile-msiof", too, as there are no current users, and it also
>> assumes the same MSIOF implementation?
>
> I'm not too familiar with the MSIOF hardware, can "renesas,sh-mobile-msiof" be
> used as a fallback for the currently support ARM SoCs ?

r8a73a4/APE6: No
r8a7740/A1: Maybe (not 100% clear to me from the datasheet)
r8a7790/R-Car H2: No
r8a7791/R-Car M2: No
sh7372/AP4: No information
sh73a0/AG5: No information

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
