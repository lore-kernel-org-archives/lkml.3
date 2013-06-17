Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3FQHHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:07:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45264 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3FQHHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com>
References: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
	<1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 17 Jun 2013 09:07:16 +0200
X-Google-Sender-Auth: 8Vjn5H22U9KteGzhx-_0wWPwMpo
Message-ID: <CAMuHMdXb5ydj-y_=3oPRLVZ4DmmrXrFQi_xxpbkg5DtzORN1gA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mn10300: Fix include dependency in irqflags.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, david.s.daney@gmail.com,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 10:06 PM,  <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
>
> We need to pick up the definition of raw_smp_processor_id() from
> asm/smp.h.  For the !SMP case, we need to supply a definition of
> raw_smp_processor_id().

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
