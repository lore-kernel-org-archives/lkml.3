Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbbANOVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:21:03 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:62386 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbANOVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:21:01 -0500
MIME-Version: 1.0
In-Reply-To: <1421244988-11794-1-git-send-email-wsa@the-dreams.de>
References: <1421244988-11794-1-git-send-email-wsa@the-dreams.de>
Date: Wed, 14 Jan 2015 15:20:59 +0100
X-Google-Sender-Auth: xSsFaA0VfJ3xPbVlPHrspzvSNrM
Message-ID: <CAMuHMdWw6mu1+Da6+HSPrAcrkDc84m2pe=fA+8nL6Zn=3AY=fA@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: of: bail out early if "dmas" property is not present
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: dmaengine@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 3:16 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
>
> And don't print an error: not configured is not an error.
>
> Reported-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
