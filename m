Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaAVO10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:27:26 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65097 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaAVO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <1390317009-8292-4-git-send-email-geert@linux-m68k.org>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
	<1390317009-8292-4-git-send-email-geert@linux-m68k.org>
Date: Wed, 22 Jan 2014 15:27:19 +0100
X-Google-Sender-Auth: -kCojkB1dB-tDcAuKl89vCeAzDs
Message-ID: <CAMuHMdUUL9RHRz3P-44PUj1APHAK5-uZ6YUN8TY9CGEm=VvMmg@mail.gmail.com>
Subject: Re: [PATCH 4/5] spi: Check that Quad/Dual is half duplex
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 4:10 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Quad and Dual SPI Transfers use all available data lines (incl. MOSI/MISO),
> hence they must be half duplex. Add a check that verify that.

Actually this is valid if SPI_LOOP is also set. Will send an update.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
