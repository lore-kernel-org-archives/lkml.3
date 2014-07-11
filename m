Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaGKO0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:26:08 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58663 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaGKO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:26:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140711091720.GO12420@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
	<1404908623-909-11-git-send-email-geert+renesas@glider.be>
	<20140711091720.GO12420@verge.net.au>
Date: Fri, 11 Jul 2014 16:26:03 +0200
X-Google-Sender-Auth: T8O6gPcc0Os68FVSpnlzASFNEso
Message-ID: <CAMuHMdXP6GfO7OEnXU8x4Sn5j8_tA2nnrFANr1sriB-B4BYoOQ@mail.gmail.com>
Subject: Re: [PATCH 10/13] [RFC] ARM: dts: Add shmobile platform device tree
 bindings documentation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Fri, Jul 11, 2014 at 11:17 AM, Simon Horman <horms@verge.net.au> wrote:
> On Wed, Jul 09, 2014 at 02:23:40PM +0200, Geert Uytterhoeven wrote:
>> Add Renesas SH-Mobile, R-Mobile, and R-Car Platform Device Tree Bindings
>> Documentation, listing supported SoCs and boards.
>>
>> This allows to use checkpatch to validate DTSes referring to Renesas
>> shmobile SoCs, and boards containing those SoCs.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Cc: linux-arm-kernel@lists.infradead.org
>
> Thanks Geert,
>
> from my point of view this seems nice. Is there a reason it is marked as an RFC?

>From the cover letter:

"The last 4 patches contain compatible strings for new R-Car Gen2 SoCs,
 which are not yet in active use, hence the RFC status."

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
