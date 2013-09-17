Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3IQOXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:23:53 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52712 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3IQOXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <1379421817-15759-5-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
	<1379421817-15759-5-git-send-email-Russ.Dill@ti.com>
Date: Tue, 17 Sep 2013 16:23:51 +0200
X-Google-Sender-Auth: q7h0ap-hEsGTdq1x5EojukuTo4k
Message-ID: <CAMuHMdVT-hhJnww64mFa6nubHrHk-ZHuoe9GwGgBCEA2G0B2Bg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/11] asm-generic: fncpy: Add function copying macros
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russ Dill <Russ.Dill@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, mans@mansr.com,
        Shawn Guo <shawn.guo@linaro.org>, Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 2:43 PM, Russ Dill <Russ.Dill@ti.com> wrote:
> +++ b/arch/alpha/include/asm/fncpy.h
> @@ -0,0 +1 @@
> +#include <asm-generic/fncpy.h>

Please add

    generic-y += fncpy.h

to arch/<arch>/include/asm/Kbuild instead.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
