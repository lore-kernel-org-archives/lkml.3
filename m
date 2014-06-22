Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaFVIGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:06:16 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:42109 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaFVIGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:06:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140621101959.GM5099@sirena.org.uk>
References: <1403259380-13634-6-git-send-email-geert+renesas@glider.be>
	<20140621101959.GM5099@sirena.org.uk>
Date: Sun, 22 Jun 2014 10:06:08 +0200
X-Google-Sender-Auth: GmcesWT6iRCqy_fFARL_RXkBpKw
Message-ID: <CAMuHMdXB4U=tkGgV=UE5KRBgP7jqyB8Wpjn1x6ei-wq-MYkLqQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] spi: sh-msiof: Add DMA support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Jun 21, 2014 at 12:19 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jun 20, 2014 at 12:16:20PM +0200, Geert Uytterhoeven wrote:
>> Add DMA support to the MSIOF driver using platform data.
>
> This doesn't apply against current code, can you please check and
> resend?

My patches were based on your for-next branch, which has
commit 1e8231b79ccbb3e6e7b3f6af9f998dca16b00efe
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Apr 29 17:21:25 2014 +0900

    spi: sh-msiof: remove unnecessary OOM messages

(from topic/cleanup), but topic/sh-msiof hasn't.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
