Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934884AbaH0OZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:25:29 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33158 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935018AbaH0OZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <1409148376-12206-1-git-send-email-geert+renesas@glider.be>
References: <1409148376-12206-1-git-send-email-geert+renesas@glider.be>
Date: Wed, 27 Aug 2014 16:25:21 +0200
X-Google-Sender-Auth: HY2urJXxSQJemkZU5dO4P5OgddY
Message-ID: <CAMuHMdUfE_dwVh=jsqCc3p_TimRaLtWzNfAu9QBwZR1o5Lt1Mg@mail.gmail.com>
Subject: Re: [PATCH] regmap: Make sure regmap_init() returns non-NULL on failure
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mark Brown <broonie@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Warren <swarren@nvidia.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against today's regmap/for-next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
