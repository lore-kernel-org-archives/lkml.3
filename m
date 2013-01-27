Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3A0KoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:44:04 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:65203 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3A0KoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
References: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 27 Jan 2013 11:43:59 +0100
X-Google-Sender-Auth: 3wOGkN4YGD-_0b_Nc2zdE49oyO0
Message-ID: <CAMuHMdU=4+AZDTHABzwkEEeDQNtMZfWgb23Tf1f1befofGMcQQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Provide dma_mmap_coherent() and dma_get_sgtable()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 11:33 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> I'll add this to the m68k for-next branch, so hopefully we can get an
> unbroken build in 3.8.

Sorry, I meant "for-linus", as it's destined for 3.8, not 3.9.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
