Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3KRNfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:35:21 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54162 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab3KRNdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131118130616.GI13640@lee--X1>
References: <1384779449-1888-1-git-send-email-geert@linux-m68k.org>
	<20131118130616.GI13640@lee--X1>
Date: Mon, 18 Nov 2013 14:33:30 +0100
X-Google-Sender-Auth: _jEVdHO3nDqEknx-vgcJEDhjjOk
Message-ID: <CAMuHMdWKi9oPJnn92ARAZG6qnFgxwfBrKCLnYdVv8MNUVjJCyA@mail.gmail.com>
Subject: Re: [PATCH] mfd: Constify struct mfd_cell where possible
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 2:06 PM, Lee Jones <lee.jones@linaro.org> wrote:
> In the interests of bisectability and revertability, I'd prefer one
> patch per file-change where possible please. Or at the very least in
> groups of files, so one for tps*, another one for max*, etc.

Done. More SoB-credits for me ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
