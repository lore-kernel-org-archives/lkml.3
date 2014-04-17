Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaDQQHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:07:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:61720 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaDQQHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:07:30 -0400
MIME-Version: 1.0
In-Reply-To: <1397742261-15621-11-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
	<1397742261-15621-11-git-send-email-will.deacon@arm.com>
Date: Thu, 17 Apr 2014 18:07:28 +0200
X-Google-Sender-Auth: Ft1ODpA_oRVTm_g3pxSzCmL-xNs
Message-ID: <CAMuHMdV15kdRincp9EbVhEUDSp4GzP86BLRFV8X_Zbhq+hwX0g@mail.gmail.com>
Subject: Re: [PATCH 10/18] m68k: io: implement dummy relaxed accessor macros
 for writes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        David Howells <dhowells@redhat.com>, Mark Brown <broonie@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 3:44 PM, Will Deacon <will.deacon@arm.com> wrote:
> write{b,w,l}_relaxed are implemented by some architectures in order to
> permit memory-mapped I/O accesses with weaker barrier semantics than the
> non-relaxed variants.
>
> This patch adds dummy macros for the write accessors to m68k, in the
> same vein as the dummy definitions for the relaxed read accessors.
> Additionally, the existing relaxed read accessors are moved into
> asm/io.h, so that they can be used by m68k targets with an MMU.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
