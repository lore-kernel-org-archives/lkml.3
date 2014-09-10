Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaIJMhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:37:50 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61703 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaIJMhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <7hfvg0kdk2.fsf@deeprootsystems.com>
References: <1410183344-14756-1-git-send-email-geert+renesas@glider.be>
	<1410183344-14756-5-git-send-email-geert+renesas@glider.be>
	<7hfvg0kdk2.fsf@deeprootsystems.com>
Date: Wed, 10 Sep 2014 14:37:46 +0200
X-Google-Sender-Auth: TyHKs7qu6SUKG_kWu6PU5J2DLhc
Message-ID: <CAMuHMdVz4QiRBHN43TE1-+R_zDouNMpTbak1rfmOmT4Vv0Lvxg@mail.gmail.com>
Subject: Re: [PATCH/RFC 4/5] ARM: shmobile: R-Mobile: Add DT support for PM domains
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Tue, Sep 9, 2014 at 5:40 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> +static int r8a7740_pd_a4s_suspend(void)
>> +{
>> +     /*
>> +      * The A4S domain contains the CPU core and therefore it should
>> +      * only be turned off if the CPU is in use.
>
> I think you meant "if the CPU is *not* in use."  ?  :)

Ah, this was copied from pm-r8a7740.c, which was copied from pm-sh7372.c.
The thinko has been fixed in the latter, when more advanced suspend support
was added.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
