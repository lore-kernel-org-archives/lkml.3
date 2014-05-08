Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaEHKMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:12:33 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44770 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaEHKMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <1399411579-10681-1-git-send-email-geert+renesas@glider.be>
References: <1399411579-10681-1-git-send-email-geert+renesas@glider.be>
Date: Thu, 8 May 2014 12:12:29 +0200
X-Google-Sender-Auth: eY4_ejiMcJBAduKBOlCm8xLIocU
Message-ID: <CAMuHMdWwenyU1RS4c8spFcb7M0oCXP9z8zbGQ0VACKj7EbvvkA@mail.gmail.com>
Subject: Re: [PATCH v4] drivers: sh: compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 11:26 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Tested on Koelsch (legacy, reference, shmobile, and shmobile+bbb kernels)
> and BeagleBone Black (shmobile+bbb). Will test on more hardware tomorrow.

Tested on genmai with Wolfram's CCF support.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
