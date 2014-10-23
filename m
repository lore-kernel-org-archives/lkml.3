Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaJWRvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:51:18 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:59094 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaJWRvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:51:16 -0400
MIME-Version: 1.0
In-Reply-To: <1414074828-4488-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1414074828-4488-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Thu, 23 Oct 2014 19:51:14 +0200
X-Google-Sender-Auth: fJpcTANIdV_TW2UvbomC9VEF51A
Message-ID: <CAMuHMdWA7WvbzV-Na2tuTkSWFykrKU3RXCPKqWkW2rpyqPzGWA@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm: cma: Use %pa to print physical addresses
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 4:33 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Casting physical addresses to unsigned long and using %lu truncates the
> values on systems where physical addresses are larger than 32 bits. Use
> %pa and get rid of the cast instead.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
