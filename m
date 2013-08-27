Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3H0TSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:18:39 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45628 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3H0TSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130827174156.GA19152@rhlx01.hs-esslingen.de>
References: <521AED72.8050105@xs4all.nl>
	<20130827174156.GA19152@rhlx01.hs-esslingen.de>
Date: Tue, 27 Aug 2013 21:18:37 +0200
X-Google-Sender-Auth: 0_4TeKispeVCqIZYKzNR2StF6u8
Message-ID: <CAMuHMdWNHdknFyz3NXJJZJrSL61Bi-v-34hVh4-8eS2ArnBaKA@mail.gmail.com>
Subject: Re: weird keyboard issue (ps/2 port?) 3.9.x/3.10.x?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 7:41 PM, Andreas Mohr <andi@lisas.de> wrote:
> while :; do clear; cat /proc/interrupts; sleep 1; done

watch cat /proc/interrupts

(yes, I spent ca. 15 years of my life using a similar loop ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
