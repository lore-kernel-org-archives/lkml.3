Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaELIFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:05:48 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50450 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaELIFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140511100502.1491.qmail@ns.horizon.com>
References: <20140511100211.1334.qmail@ns.horizon.com>
	<20140511100502.1491.qmail@ns.horizon.com>
Date: Mon, 12 May 2014 10:05:45 +0200
X-Google-Sender-Auth: Y7Hiaf-sf8vG0K4V_ChVjfPc2GY
Message-ID: <CAMuHMdWxwwfPMYmAnrbF-PLaZiDNr4=F5izgNkxVXz7EQZqMtA@mail.gmail.com>
Subject: Re: [PATCH 2/3] drivers/mmc/host/mmc_spi.c: Use get/put_unaligned_be32
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: George Spelvin <linux@horizon.com>
Cc: Pavel Machek <pavel@ucw.cz>, arik@wizery.com, david.gnedt@davizone.at,
        eliad@wizery.com, jan.nikitenko@gmail.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>, luca@coelho.fi,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 12:05 PM, George Spelvin <linux@horizon.com> wrote:
> Very minor source and binary size reduction.
>
> Signed-off-by: George Spelvin <linux@horizon.com>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
