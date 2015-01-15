Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbbAONHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:07:35 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55919 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbbAONHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:07:30 -0500
MIME-Version: 1.0
In-Reply-To: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
References: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 15 Jan 2015 14:07:28 +0100
X-Google-Sender-Auth: 4oA6gPY9UsyOl0eznwn66YTQYIk
Message-ID: <CAMuHMdX9LePOdoX4_TL5_Upr6_bxUSDpxBA+4JsLd=Z_dSht=A@mail.gmail.com>
Subject: Re: [PATCH 0/5] m68k/atari: Remove obsolete IRQ_TYPE_*
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 9:40 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> IRQ_TYPE_SLOW, IRQ_TYPE_FAST, and IRQ_TYPE_PRIO are no longer used by
> the Atari platform interrupt code since commit 734085651c9b80aa
> ("[PATCH] m68k: convert atari irq code") in v2.6.18-rc1, so drop them.
>
> Note that their values have been reused for different purposes
> (IRQ_TYPE_NONE, IRQ_TYPE_EDGE_RISING, and IRQ_TYPE_EDGE_FALLING) since
> commit 6a6de9ef5850d063 ("[PATCH] genirq: core") in v2.6.18-rc1.
>
> The last patch depends on the first 4 patches.
> Please either apply the relevant patches (1, 3 or 4; parport has no
> maintainer) to your trees, or ack them.

Applied with maintainers' acks, and queued for 3.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
