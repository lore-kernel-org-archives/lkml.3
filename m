Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaHEOeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:34:44 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56764 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaHEOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:34:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140714185830.GE6800@sirena.org.uk>
References: <1405094802-14401-1-git-send-email-geert+renesas@glider.be>
	<20140714185830.GE6800@sirena.org.uk>
Date: Tue, 5 Aug 2014 16:34:40 +0200
X-Google-Sender-Auth: X4g82NTAuTcJFbE7RMgfttux04w
Message-ID: <CAMuHMdX4bDMogeSwmd3bxm_fKpjouxZJFT_dd5ErxgJkZ2U=cA@mail.gmail.com>
Subject: Re: [PATCH 1/2] spi: rspi: Fix leaking of unused DMA descriptors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        linux-spi <linux-spi@vger.kernel.org>, dmaengine@vger.kernel.org,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jul 14, 2014 at 8:58 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 11, 2014 at 06:06:41PM +0200, Geert Uytterhoeven wrote:
>> If dmaengine_prep_slave_sg() or dmaengine_submit() fail, we may leak
>> unused DMA descriptors.
>
> This doesn't apply, I guess it may depend on some of your other DMA
> related patches but it's not immediately obvious and it's not been sent
> as part of a series.  Can you please check and/or clarify?

Indeed, this (and the rspi one) depended on the two "Handle
dmaengine_prep_slave_single() failures gracefully" patches.

Unless you recover them from e.g. patchwork, I'll resend them with my
next batch.

Sorry for the fuzz.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
