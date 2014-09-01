Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaIAQky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:40:54 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:42868 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaIAQkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <1601192.oClrOJlUe8@amdc1032>
References: <1601192.oClrOJlUe8@amdc1032>
Date: Mon, 1 Sep 2014 18:40:50 +0200
X-Google-Sender-Auth: WNP-QFKK01vLG_k0f-7JaAVsj0U
Message-ID: <CAMuHMdVp16nXS1GefyV0OD7Dwewct0UPTEEYLj+GKCrnBxjhLw@mail.gmail.com>
Subject: Re: [PATCH v2] usb: renesas_usbhs: fix driver dependencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 4:24 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> Renesas USBHS controller support should be available only on
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
