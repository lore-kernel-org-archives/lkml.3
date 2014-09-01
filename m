Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaIAQgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:36:23 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:50711 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaIAQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <1749721.1a6rN6K2Gg@amdc1032>
References: <1749721.1a6rN6K2Gg@amdc1032>
Date: Mon, 1 Sep 2014 18:36:19 +0200
X-Google-Sender-Auth: 77lej8MkoiU4CNpByx1SYNtTp10
Message-ID: <CAMuHMdWGdD+-o9Z8gPYwJWJmjhBqfw0HA4ve=RH+adLFJEZa8Q@mail.gmail.com>
Subject: Re: [PATCH v2] net: sh_eth: fix driver dependencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: "David S. Miller" <davem@davemloft.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 4:25 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> Renesas SuperH Ethernet support should be available only on
> Renesas ARM SoCs and SuperH architecture.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> ---
> v2:
> - s/ARCH_SH/SUPERH/ (thanks to Sergei Shtylyov)

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
