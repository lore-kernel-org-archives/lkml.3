Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaDELfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 07:35:52 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48425 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaDELfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 07:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <533E8E49.1030307@ti.com>
References: <1396355974-2257-1-git-send-email-jon@ringle.org>
	<1396355974-2257-2-git-send-email-jon@ringle.org>
	<533E8E49.1030307@ti.com>
Date: Sat, 5 Apr 2014 13:35:30 +0200
X-Google-Sender-Auth: obasuxOE3uP-TFAB7H0uH01DwU0
Message-ID: <CAMuHMdWnVxh5PSUrTRW0+f0WEN91-C9WLRBqT55STg2N5v4+RA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] video: da8xx-fb: Fix casting of info->pseudo_palette
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: jon@ringle.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Jon Ringle <jringle@gridpoint.com>,
        "Etheridge, Darren" <detheridge@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Fri, Apr 4, 2014 at 12:49 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> I wonder why the pseudo_palette in fb.h is 'void *' in the first place.
> It seems to be cast to 'u32 *' everywhere...

Historically, this was driver-specific. Many drivers stored u16 pixel values.

I guess it can be changed to u32 now, dropping all casts.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
