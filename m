Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3FQH20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:28:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63455 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3FQH2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <1371413189-2568-2-git-send-email-ddaney.cavm@gmail.com>
References: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
	<1371413189-2568-2-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 17 Jun 2013 09:28:24 +0200
X-Google-Sender-Auth: UVYMKDXx4er0azwR-NBKTYyANAw
Message-ID: <CAMuHMdXQxacjQHMCxvOVx6FduXnWmsKvCjSsHX9U3kpR0b8wiQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ia64: Fix include dependency in asm/irqflags.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, david.s.daney@gmail.com,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 10:06 PM,  <ddaney.cavm@gmail.com> wrote:
> asm/kregs.h isn't always included first, so we need an explicit include.

Thanks, this fixes the build!

> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
